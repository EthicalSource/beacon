class NotificationJob < ApplicationJob

  queue_as :notifications

  def self.perform(account_id, project_id, issue_id, issue_comment_id)
    NotificationService.notify(
      account_id: account_id,
      project_id: project_id,
      issue_id: issue_id,
      issue_comment_id: issue_comment_id
    )
  end

end
