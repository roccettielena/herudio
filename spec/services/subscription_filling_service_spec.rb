require 'rails_helper'

RSpec.describe SubscriptionFillingService do
  subject { described_class.new }

  describe '#fill_subscriptions_for' do
    it 'fills the subscriptions for the given time frame' do
      lesson = FactoryGirl.build_stubbed(:lesson)

      expect(Lesson).to receive(:available_for)
        .with(lesson.time_frame)
        .once
        .and_return([lesson])

      user = FactoryGirl.build_stubbed(:user)
      expect(user.subscriptions).to receive(:create!)
        .with(lesson: lesson)
        .once

      relation = instance_double('ActiveRecord::Relation')
      expect(relation).to receive(:find_each)
        .once
        .and_yield(user)

      expect(User).to receive(:with_no_occupations_for)
        .with(lesson.time_frame)
        .once
        .and_return(relation)

      subject.fill_subscriptions_for(lesson.time_frame)
    end
  end
end
