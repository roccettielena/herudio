class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update).concat([:group_id])
    devise_parameter_sanitizer.for(:accept_invitation).concat([:group_id])
  end

  def raise_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def redirect_back_or(default, *options)
    destination = request.referer.present? ? :back : default
    redirect_to destination, *options
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || courses_path
  end
end
