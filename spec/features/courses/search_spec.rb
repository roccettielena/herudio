# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Courses search' do
  scenario 'user can search the courses by name' do
    FactoryGirl.create(:course, name: 'Foocourse')
    FactoryGirl.create(:course, name: 'Barcourse')

    visit root_path
    click_link I18n.t('layout.nav.courses')

    fill_in I18n.t('layout.course_search.placeholder'), with: 'foo'
    click_button 'search-submit'

    expect(page).to have_content 'Foocourse'
    expect(page).not_to have_content 'Barcourse'
  end

  scenario 'user can search the courses by category' do
    FactoryGirl.create(:course,
      name: 'Foocourse',
      category: FactoryGirl.create(:course_category,
        name: 'Test category'))

    FactoryGirl.create(:course, name: 'Barcourse')

    visit root_path
    click_link I18n.t('layout.nav.courses')

    click_link 'Test category'

    expect(page).to have_content 'Foocourse'
    expect(page).not_to have_content 'Barcourse'
  end
end
