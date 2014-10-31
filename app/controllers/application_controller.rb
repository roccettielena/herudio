class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def raise_404
    raise ActionController::RoutingError.new('Not Found')
  end

  def redirect_back_or(default, *options)
    destination = request.referer.present? ? :back : default
    redirect_to destination, *options
  end
end
