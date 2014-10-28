require 'rails_helper'

RSpec.feature 'Sign in' do
  scenario 'user can sign in with valid credentials' do
    user = FactoryGirl.create(:user)
    signin(user.email, user.password)
    expect(page).to have_content I18n.t('devise.sessions.signed_in')
  end
end
