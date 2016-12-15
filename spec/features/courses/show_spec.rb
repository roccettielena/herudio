# frozen_string_literal: true
require 'rails_helper'

RSpec.feature 'Courses show' do
  background do
    allow(Subscription).to receive(:open?)
      .and_return(true)
  end

  given!(:course) { FactoryGirl.create(:course) }
  given!(:lesson) { FactoryGirl.create(:lesson, course: course) }

  scenario 'user can view the course' do
    visit root_path
    click_link I18n.t('layout.nav.courses')
    click_link course.name

    expect(page).to have_content course.name
  end

  scenario 'user can view the lessons' do
    visit root_path
    click_link I18n.t('layout.nav.courses')
    click_link course.name

    expect(page).to have_content lesson.decorate.starts_at
  end

  scenario 'user can subscribe to the lessons' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password

    visit root_path
    click_link I18n.t('layout.nav.courses')
    click_link course.name

    click_link I18n.t('helpers.subscriptions.subscribe')

    expect(page).to have_content I18n.t('controllers.subscriptions.create.subscribed')
  end

  scenario 'user can unsubscribe from the lessons' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password
    FactoryGirl.create(:subscription, user: user, lesson: lesson, origin: :manual)

    visit root_path
    click_link I18n.t('layout.nav.courses')
    click_link course.name

    click_link I18n.t('helpers.subscriptions.unsubscribe')

    expect(page).to have_content I18n.t('controllers.subscriptions.destroy.unsubscribed')
  end
end
