class ApplicationMailer < AsyncMailer
  default from: ENV.fetch('ROBOT_EMAIL_ADDRESS')
  layout 'mailer'
end
