# frozen_string_literal: true
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name,
      :last_name,
      :group,
      :birth_date,
      :birth_location,
      :group_id
    ])

    devise_parameter_sanitizer.permit(:accept_invitation)
  end

  def raise_404
    fail ActionController::RoutingError, 'Not Found'
  end

  def redirect_back_or(default, *options)
    destination = request.referer.present? ? :back : default
    redirect_to destination, *options
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || courses_path
  end
end
