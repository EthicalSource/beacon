# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
Rails.application.config.filter_parameters += [
  :password,
  :issue_id,
  :email,
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  :account_id,
  :project_id,
  :temp_2fa_code,
  :confirmation_token,
  :reset_password_token,
  :confirmation_token,
  :id
]
