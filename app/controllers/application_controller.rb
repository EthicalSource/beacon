class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  breadcrumb 'Home', :root_path

  def render_not_found
    params[:account]&.delete(:password)
    ActivityLoggingService.log(current_account, :four_o_fours) if current_account
    SuspiciousActivityLog.create(
      controller: self.class.to_s,
      action: action_name,
      ip_address: request.remote_ip,
      params: params.to_json,
      account_id: current_account ? current_account.id : nil
    )
    SuspiciousActivityLog.throttle(request.remote_ip)
    render "errors/show", status: 404
  end

  def render_forbidden
    params[:account]&.delete(:password)
    SuspiciousActivityLog.create(
      controller: self.class.to_s,
      action: action_name,
      ip_address: request.remote_ip,
      params: params.to_json,
      account_id: current_account ? current_account.id : nil
    )
    SuspiciousActivityLog.throttle(request.remote_ip)
    render "errors/forbidden", status: :forbidden
  end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name])
    end

end
