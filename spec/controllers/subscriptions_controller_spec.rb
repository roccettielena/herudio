# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubscriptionsController do
  before do
    allow(Subscription).to receive(:open?)
      .and_return(true)
  end

  let(:current_user) { FactoryGirl.create(:user) }
  before { sign_in current_user }

  let!(:lesson) { FactoryGirl.create(:lesson) }
  let(:course) { lesson.course }

  describe "GET 'index'" do
    let(:subscription) { FactoryGirl.create(:subscription, user: current_user) }

    it 'retrieves the subscriptions' do
      get :index
      expect(assigns(:subscriptions)).to eq([subscription])
    end
  end

  describe "POST 'create'" do
    context 'when the user is not subscribed to the lesson' do
      it 'creates the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.to change(lesson.subscriptions, :count).by(1)
      end
    end

    context 'when subscriptions are closed' do
      before do
        allow(Subscription).to receive(:closed?)
          .and_return(true)
      end

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when the user is already subscribed to the lesson' do
      before { FactoryGirl.create(:subscription, user: current_user, lesson: lesson) }

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when there are no seats available' do
      before { course.update_column :seats, 0 }

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when the subscription is to a past lesson' do
      before do
        lesson.time_frame.update_column :ends_at, Time.zone.now - 1.hour
      end

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when the lesson is in conflict with a subscribed lesson' do
      before do
        FactoryGirl.create(:subscription,
          user: current_user,
          lesson: FactoryGirl.create(:lesson,
            time_frame: FactoryGirl.create(:time_frame,
              starts_at: lesson.starts_at,
              ends_at: lesson.ends_at)))
      end

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when the lesson is in conflict with an organized lesson' do
      before do
        FactoryGirl.create(:lesson,
          course: FactoryGirl.create(:course,
            organizers: [current_user]),
          time_frame: FactoryGirl.create(:time_frame,
            starts_at: lesson.starts_at,
            ends_at: lesson.ends_at))
      end

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end
  end

  describe "DELETE 'destroy'" do
    context 'when subscriptions are closed' do
      before do
        allow(Subscription).to receive(:closed?)
          .and_return(true)
      end

      it 'does not destroy the subscription' do
        expect {
          delete :destroy, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when the user is subscribed to the lesson' do
      before do
        FactoryGirl.create(:subscription, user: current_user, lesson: lesson, origin: :manual)
      end

      it 'destroys the subscription' do
        expect {
          delete :destroy, course_id: course.id, lesson_id: lesson.id
        }.to change(lesson.subscriptions, :count).by(-1)
      end

      context 'when the subscription is to a past lesson' do
        before do
          lesson.time_frame.update_column :ends_at, Time.zone.now - 1.hour
        end

        it 'does not destroy the subscription' do
          expect {
            delete :destroy, course_id: course.id, lesson_id: lesson.id
          }.not_to change(lesson.subscriptions, :count)
        end
      end
    end

    context 'when the user is not subscribed to the lesson' do
      it 'does not destroy the subscription' do
        expect {
          delete :destroy, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end
  end
end
