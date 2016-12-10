# frozen_string_literal: true
class Users::InvitationsController < Devise::InvitationsController
  def new
    raise_404
  end

  def create
    raise_404
  end

  def edit
    raise_404 unless ENV.fetch('REGISTRATION_TYPE') == 'invitation'
    super
  end

  def update
    raise_404 unless ENV.fetch('REGISTRATION_TYPE') == 'invitation'
    super
  end

  def destroy
    raise_404
  end
end
