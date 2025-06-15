# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :issue_id,
  :email,
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
  :account_id,
  :project_id,
  :temp_2fa_code,
  :confirmation_token,
  :reset_password_token,
  :confirmation_token,
  :id
]
