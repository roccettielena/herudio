require 'rails_helper'

RSpec.feature 'Courses show' do
  given!(:course) { FactoryGirl.create(:course) }

  background do
    visit root_path
  end

  scenario 'user can view the course' do
    click_link course.name
    expect(page).to have_content course.name
  end

  scenario 'user can view the lessons' do
    lesson = FactoryGirl.create(:lesson, course: course)
    click_link course.name
    expect(page).to have_content lesson.decorate.starts_at
  end
end
