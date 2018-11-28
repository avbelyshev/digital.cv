class ApplicationController < ActionController::Base
  helper Rails.application.routes.url_helpers
  include Passwordless::ControllerHelpers

  protect_from_forgery with: :exception

  helper_method :current_user

  private

  def current_user
    @current_user ||= authenticate_by_cookie(User)
  end

  def require_user!
    return if current_user
    save_passwordless_redirect_location!(User)
    redirect_to root_path, alert: 'You are not worthy!'
  end
end
