# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Profile edit' do
  scenario 'user can edit the profile' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password
    visit root_path
    click_link user.full_name
    click_link I18n.t('layout.nav.edit_profile')

    fill_in I18n.t('simple_form.labels.user.current_password'), with: user.password
    click_button I18n.t('devise.registrations.edit.submit')

    expect(page).to have_content I18n.t('devise.registrations.updated')
  end
end
