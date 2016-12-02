# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Confirmation request' do
  scenario 'user can request a confirmation email' do
    user = FactoryGirl.create(:user, confirmed_at: nil)
    visit root_path
    click_link I18n.t('layout.nav.sign_in')
    click_link I18n.t('devise.sessions.new.hints.confirmation')

    fill_in I18n.t('simple_form.labels.user.email'), with: user.email
    click_button I18n.t('devise.confirmations.new.submit')

    expect(page).to have_content I18n.t('devise.confirmations.send_instructions')
  end
end
