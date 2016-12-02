# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Invitations' do
  scenario 'user can set a password' do
    group = FactoryGirl.create(:user_group)

    user_attributes = FactoryGirl.attributes_for(:user)

    user = FactoryGirl.build(:user, group: nil)
    user.save! && user.invite!

    visit accept_user_invitation_path(invitation_token: user.raw_invitation_token)

    select group.name, from: I18n.t('simple_form.labels.user.group')
    fill_in I18n.t('simple_form.labels.user.password'), with: user_attributes[:password]
    fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: user_attributes[:password]

    click_button I18n.t('devise.invitations.edit.submit')

    expect(page).to have_content I18n.t('devise.invitations.updated')
  end
end
