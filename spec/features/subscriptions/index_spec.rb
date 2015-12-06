require 'rails_helper'

RSpec.feature 'Subscriptions index' do
  background do
    allow(Subscription).to receive(:open?)
      .and_return(true)
  end

  given!(:current_user) { FactoryGirl.create(:user) }
  given!(:subscription) { FactoryGirl.create(:subscription, user: current_user) }

  background do
    signin current_user.email, current_user.password

    visit root_path
    click_link current_user.full_name
    click_link I18n.t('layout.nav.subscriptions')
  end

  scenario 'user can view the subscriptions' do
    expect(page).to have_content subscription.course.name
  end

  scenario 'user can unsubscribe from the lessons' do
    click_link I18n.t('helpers.subscriptions.unsubscribe')
    expect(page).to have_content I18n.t('controllers.subscriptions.destroy.unsubscribed')
  end
end
