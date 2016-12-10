# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  def new
    raise_404 unless ENV.fetch('REGISTRATION_TYPE') == 'regular'
    super
  end

  def create
    raise_404 unless ENV.fetch('REGISTRATION_TYPE') == 'regular'
    super
  end

  def cancel
    raise_404
  end

  def destroy
    raise_404
  end
end
