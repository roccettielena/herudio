require 'rails_helper'

RSpec.describe SubscriptionsController do
  let(:current_user) { FactoryGirl.create(:user)}
  before { sign_in current_user }

  let!(:lesson) { FactoryGirl.create(:lesson) }

  describe "POST 'create'" do
    context 'when the user is not subscribed to the lesson' do
      it 'creates the subscription' do
        expect {
          post :create, course_id: lesson.course.id, lesson_id: lesson.id
        }.to change(lesson.subscriptions, :count).by(1)
      end
    end

    context 'when the user is already subscribed to the lesson' do
      before { FactoryGirl.create(:subscription, user: current_user, lesson: lesson) }

      it 'does not create the subscription' do
        expect {
          post :create, course_id: lesson.course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end
  end

  describe "DELETE 'destroy'" do
    context 'when the user is subscribed to the lesson' do
      before { FactoryGirl.create(:subscription, user: current_user, lesson: lesson) }

      it 'destroys the subscription' do
        expect {
          delete :destroy, course_id: lesson.course.id, lesson_id: lesson.id
        }.to change(lesson.subscriptions, :count).by(-1)
      end
    end

    context 'when the user is not subscribed to the lesson' do
      it 'does not destroy the subscription' do
        expect {
          delete :destroy, course_id: lesson.course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end
  end
end
