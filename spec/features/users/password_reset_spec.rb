# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Password reset edit' do
  scenario 'user can edit the password' do
    user = FactoryGirl.create(:user)
    token = user.send_reset_password_instructions
    visit edit_user_password_path(reset_password_token: token)

    fill_in I18n.t('simple_form.labels.user.new_password'), with: 'newpassword'
    fill_in I18n.t('simple_form.labels.user.password_confirmation'), with: 'newpassword'
    click_button I18n.t('devise.passwords.edit.submit')

    expect(page).to have_content I18n.t('devise.passwords.updated')
  end
end
