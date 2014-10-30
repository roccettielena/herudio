require 'rails_helper'

RSpec.feature 'Courses show' do
  given!(:course) { FactoryGirl.create(:course) }
  given!(:lesson) { FactoryGirl.create(:lesson, course: course) }

  scenario 'user can view the course' do
    visit root_path
    click_link course.name

    expect(page).to have_content course.name
  end

  scenario 'user can view the lessons' do
    visit root_path
    click_link course.name

    expect(page).to have_content lesson.decorate.starts_at
  end

  scenario 'user can subscribe to the lessons' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password

    visit root_path
    click_link course.name

    click_link I18n.t('controllers.courses.show.lessons.subscribe')

    expect(page).to have_content I18n.t('controllers.subscriptions.create.subscribed')
  end

  scenario 'user can unsubscribe from the lessons' do
    user = FactoryGirl.create(:user)
    signin user.email, user.password
    FactoryGirl.create(:subscription, user: user, lesson: lesson)

    visit root_path
    click_link course.name

    click_link I18n.t('controllers.courses.show.lessons.unsubscribe')

    expect(page).to have_content I18n.t('controllers.subscriptions.destroy.unsubscribed')
  end
end
