require 'rails_helper'

RSpec.feature 'Sign out' do
  scenario 'user can sign out' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password

    click_link user.full_name
    click_link I18n.t('layout.nav.sign_out')

    expect(page).to have_content I18n.t('devise.sessions.signed_out')
  end
end
