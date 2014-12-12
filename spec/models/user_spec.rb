RSpec.describe User do
  subject { FactoryGirl.build(:user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(full_name group).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  describe '#subscription_to' do
    subject { User.new }

    it 'returns the subscription to the lesson' do
      lesson = stub()
      subscription = stub()

      subject
        .subscriptions
        .expects(:find_by)
        .with(lesson: lesson)
        .once
        .returns(subscription)

      expect(subject.subscription_to(lesson)).to eq(subscription)
    end
  end

  describe '#subscribed_to?' do
    subject { User.new }

    let(:lesson) { stub(id: 1) }

    context 'when the user is subscribed to the lesson' do
      before do
        subject
          .expects(:subscription_to)
          .with(lesson)
          .once
          .returns(stub())
      end

      it 'returns true' do
        expect(subject).to be_subscribed_to(lesson)
      end
    end

    context 'when the user is not subscrbed to the lesson' do
      before do
        subject
          .expects(:subscription_to)
          .with(lesson)
          .once
          .returns(nil)
      end

      it 'returns false' do
        expect(subject).not_to be_subscribed_to(lesson)
      end
    end
  end

  describe '.with_no_subscriptions_for' do
    let!(:frame) { FactoryGirl.create :time_frame }
    let!(:lesson) { FactoryGirl.create :lesson, time_frame: frame }

    let!(:subscribed_user) { FactoryGirl.create(:subscription, lesson: lesson).user }
    let!(:unsubscribed_user) { FactoryGirl.create(:subscription).user }

    let(:result) { User.with_no_subscriptions_for(frame) }

    it 'returns the users with no subscriptions to the given time frame' do
      expect(result).to include(unsubscribed_user)
      expect(result).not_to include(subscribed_user)
    end
  end

  describe '.with_no_organized_lessons_for' do
    let!(:frame) { FactoryGirl.create(:time_frame) }
    let!(:lesson) do
      FactoryGirl.create(:lesson,
        time_frame: frame,
        course: FactoryGirl.create(:course,
          organizers: [organizer_user]
        )
      )
    end

    let!(:organizer_user) { FactoryGirl.create(:user) }
    let!(:not_organizer_user) { FactoryGirl.create(:user) }

    let(:result) { User.with_no_organized_lessons_for(frame) }

    it 'returns the users with no subscriptions to the given time frame' do
      expect(result).to include(not_organizer_user)
      expect(result).not_to include(organizer_user)
    end
  end
end
