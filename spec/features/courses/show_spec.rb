require 'rails_helper'

RSpec.feature 'Courses show' do
  scenario 'user can view the course' do
    course = FactoryGirl.create(:course)
    visit root_path
    click_link course.name
    expect(page).to have_content course.name
  end
end
