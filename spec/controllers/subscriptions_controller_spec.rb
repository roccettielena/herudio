require 'rails_helper'

RSpec.describe SubscriptionsController do
  let(:current_user) { FactoryGirl.create(:user)}
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

    context 'when the user is already subscribed to the lesson' do
      before { FactoryGirl.create(:subscription, user: current_user, lesson: lesson) }

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    context 'when there are no seats available' do
      before(:each) do
        course
          .lessons
          .expects(:find)
          .once
          .with(lesson.id.to_s)
          .returns(lesson)

        Course
          .expects(:find)
          .with(course.id.to_s)
          .once
          .returns(course)

        lesson
          .expects(:available_seats)
          .once
          .returns(0)
      end

      it 'does not create the subscription' do
        expect {
          post :create, course_id: course.id, lesson_id: lesson.id
        }.not_to change(lesson.subscriptions, :count)
      end
    end

    %w(subscribed organized).each do |association|
      context "when the lesson is in conflict with a #{association} lesson" do
        before(:each) do
          course
            .lessons
            .expects(:find)
            .once
            .with(lesson.id.to_s)
            .returns(lesson)

          Course
            .expects(:find)
            .with(course.id.to_s)
            .once
            .returns(course)

          lesson.stubs(conflicting_for?: false)

          lesson
            .expects(:conflicting_for?)
            .with(current_user, [association.to_sym])
            .once
            .returns(true)
        end

        it 'does not create the subscription' do
          expect {
            post :create, course_id: course.id, lesson_id: lesson.id
          }.not_to change(lesson.subscriptions, :count)
        end
      end
    end
  end

  describe "DELETE 'destroy'" do
    context 'when the user is subscribed to the lesson' do
      before { FactoryGirl.create(:subscription, user: current_user, lesson: lesson) }

      it 'destroys the subscription' do
        expect {
          delete :destroy, course_id: course.id, lesson_id: lesson.id
        }.to change(lesson.subscriptions, :count).by(-1)
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
