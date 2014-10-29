require 'rails_helper'

RSpec.feature 'Contact page' do
  scenario 'visit the contact page' do
    visit root_path
    click_link I18n.t('layout.nav.contact')
    expect(page).to have_content I18n.t('pages.contact.title')
  end
end
