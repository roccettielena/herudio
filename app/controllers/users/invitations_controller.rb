class Users::InvitationsController < Devise::InvitationsController
  def new
    raise_404
  end

  def create
    raise_404
  end

  def destroy
    raise_404
  end

  private

  def accept_resource
    token = update_resource_params['invitation_token']
    resource = resource_class.find_by_invitation_token(token, false)

    raise ActiveRecord::NotFound if !resource

    resource.validate_group!
    resource.assign_attributes(update_resource_params.except('invitation_token'))
    resource.accept_invitation!

    resource
  end
end
