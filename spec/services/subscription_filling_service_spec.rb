require 'rails_helper'

RSpec.describe SubscriptionFillingService do
  subject { described_class.new }

  describe '#fill_subscriptions_for' do
    it 'fills the subscriptions for the given time frame' do
      lesson = FactoryGirl.build_stubbed(:lesson)

      Lesson
        .expects(:available_for)
        .with(lesson.time_frame)
        .once
        .returns([lesson])

      user = FactoryGirl.build_stubbed(:user)
      user
        .subscriptions
        .expects(:create!)
        .with(lesson: lesson)
        .once

      relation = stub()
      relation
        .expects(:find_each)
        .once
        .yields(user)

      User
        .expects(:with_no_subscriptions_for)
        .with(lesson.time_frame)
        .once
        .returns(relation)

      subject.fill_subscriptions_for(lesson.time_frame)
    end
  end
end
