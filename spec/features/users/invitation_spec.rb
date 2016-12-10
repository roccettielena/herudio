# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Invitations' do
  before { ENV['REGISTRATION_TYPE'] = 'invitation' }

  scenario 'user can set a password' do
    user = FactoryGirl.create(:user).tap do |u|
      u.invite!
    end

    user_attributes = FactoryGirl.attributes_for(:user)

    visit accept_user_invitation_path(invitation_token: user.raw_invitation_token)

    fill_in I18n.t('simple_form.labels.user.password'), with: user_attributes[:password]
    fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: user_attributes[:password]

    click_button I18n.t('devise.invitations.edit.submit')

    expect(page).to have_content I18n.t('devise.invitations.updated')
  end
end
