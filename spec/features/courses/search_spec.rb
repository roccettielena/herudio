require 'rails_helper'

RSpec.feature 'Courses search' do
  scenario 'user can search the courses' do
    matching_course = FactoryGirl.create(:course, name: 'Foocourse')
    nonmatching_course = FactoryGirl.create(:course, name: 'Barcourse')
    visit root_path

    fill_in I18n.t('layout.course_search.placeholder'), with: 'foo'
    click_button I18n.t('layout.course_search.submit')

    expect(page).to have_content 'Foocourse'
    expect(page).not_to have_content 'Barcourse'
  end
end
