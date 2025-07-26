class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('ROBOT_EMAIL_ADDRESS')
  layout "mailer"
end
