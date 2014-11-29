require 'rails_helper'

RSpec.feature 'Courses index' do
  scenario 'user can see the courses' do
    course = FactoryGirl.create(:course)
    visit root_path
    click_link I18n.t('layout.nav.courses')
    expect(page).to have_content course.name
  end
end
