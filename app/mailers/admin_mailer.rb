class AdminMailer < ApplicationMailer

  def notify_on_abuse_report
    @report = AbuseReport.find(params[:report_id])
    @project = Project.find(params[:project_id])
    @reporter = @report&.account
    mail(to: ENV.fetch('ABUSE_EMAIL_ADDRESS'), subject: "Beacon: New Abuse Report")
  end

  def notify_on_new_contact_message
    @message = params[:contact_message]
    mail(to: ENV.fetch('SUPPORT_EMAIL_ADDRESS'), subject: "Beacon: New Contact Form")
  end

  def notify_on_flag_request
    @reporter = Account.find(params[:reporter_id])
    @account = Account.find(params[:account_id])
    @reason = params[:reason]
    @report = AbuseReport.find(params[:report_id])
    mail(to: ENV.fetch('ABUSE_EMAIL_ADDRESS'), subject: "Beacon: New Account Flag Request")
  end

  def notify_on_project_published
    @project = params[:project]
    mail(to: ENV.fetch('SUPPORT_EMAIL_ADDRESS'), subject: "Beacon: New Project Published (#{@project.name})")
  end

  def notify_on_project_name_change
    @project = params[:project]
    @old_name = params[:old_name]
    @new_name = params[:new_name]
    mail(to: ENV.fetch('SUPPORT_EMAIL_ADDRESS'), subject: "Beacon: Project name changed from #{@old_name} to #{@new_name}")
  end

end
