# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  def cancel
    raise_404
  end

  def destroy
    raise_404
  end

  protected

  def update_resource(resource, params)
    resource.validate_group!
    super(resource, params)
  end
end
