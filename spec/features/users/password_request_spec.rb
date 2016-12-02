# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Password reset request' do
  scenario 'user can request a reset email' do
    user = FactoryGirl.create(:user)
    visit root_path
    click_link I18n.t('layout.nav.sign_in')
    click_link I18n.t('devise.sessions.new.hints.password')

    fill_in I18n.t('simple_form.labels.user.email'), with: user.email
    click_button I18n.t('devise.passwords.new.submit')

    expect(page).to have_content I18n.t('devise.passwords.send_instructions')
  end
end
