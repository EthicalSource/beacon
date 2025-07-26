class NotificationService

  def self.enqueue_notification(account_id:, project_id:, issue_id:, issue_comment_id: nil)
    NotificationJob.perform_later(account_id, project_id, issue_id, issue_comment_id)
  end

  def self.enqueue_sms(project_id:, issue_id:)
    SmsNotificationJob.perform_later(project_id, issue_id)
  end

  def self.notify(account_id:, project_id:, issue_id:, issue_comment_id: nil)
    project = Project.find(project_id)
    account = Account.find(account_id)

    notification = Notification.create(
      project_id: project.id,
      issue_id: issue_id,
      issue_comment_id: issue_comment_id
    )
    account.notification_encrypted_ids << EncryptionService.encrypt(notification.id)
    account.save
  end

  def self.notified!(account:, issue_id:)
    return unless notifications = account.notifications.where(issue_id: issue_id)
    notifications.destroy_all
    account.notification_encrypted_ids = account.notifications.compact.map{ |n| EncryptionService.encrypt(n.id) }
    account.save
  end

  def self.notify_moderators_on_issue_via_sms(project_id, issue_id)
    client = Twilio::REST::Client.new(ENV.fetch('TWILIO_ACCOUNT_SID'), ENV.fetch('TWILIO_AUTH_TOKEN'))
    project = Project.find(project_id)
    issue = Issue.find(issue_id)

    project.all_moderators.each do |account|
      next unless account.send_sms_on_issue_open
      next unless account.phone_number

      begin
        body = "Issue #{issue.issue_number} has been opened on the"\
               " #{project.name} project."\
               " Please sign in to Beacon to review the issue."

        client.messages.create(
          body: body,
          to: account.phone_number,
          from: ENV.fetch('TWILIO_PHONE_NUMBER')
        )
      rescue StandardError => e
        Rails.logger.info("Failed to send SMS: #{e} #{e.backtrace}")
      end
    end
  end

end
