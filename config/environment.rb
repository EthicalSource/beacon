# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.smtp_settings = {
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_API_KEY'],
  domain: 'coc-beacon.com',
  host: 'www.coc-beacon.com',
  address: ENV['SENDGRID_SERVER'],
  port: 587,
  authentication: :plain,
  enable_starttls_auto: true
}
