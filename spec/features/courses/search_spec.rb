require 'rails_helper'

RSpec.feature 'Courses search' do
  scenario 'user can search the courses by name' do
    matching_course = FactoryGirl.create(:course, name: 'Foocourse')
    nonmatching_course = FactoryGirl.create(:course, name: 'Barcourse')
    visit root_path

    fill_in I18n.t('layout.course_search.placeholder'), with: 'foo'
    click_button I18n.t('layout.course_search.submit')

    expect(page).to have_content 'Foocourse'
    expect(page).not_to have_content 'Barcourse'
  end

  scenario 'user can search the courses by category' do
    matching_course = FactoryGirl.create(:course,
      name: 'Foocourse',
      category: FactoryGirl.create(:course_category,
        name: 'Test category'
      )
    )

    nonmatching_course = FactoryGirl.create(:course, name: 'Barcourse')

    visit root_path

    click_link 'Test category'

    expect(page).to have_content 'Foocourse'
    expect(page).not_to have_content 'Barcourse'
  end
end
