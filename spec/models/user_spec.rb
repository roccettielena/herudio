# frozen_string_literal: true
RSpec.describe User do
  subject { FactoryGirl.build(:user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(first_name last_name birth_date birth_location).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  context "when REGISTRATION_TYPE is 'regular'" do
    before { ENV['REGISTRATION_TYPE'] = 'regular' }

    context 'when no matching authorization is found' do
      before do
        allow(AuthorizedUser).to receive(:matching_user)
          .with(subject)
          .and_return(OpenStruct.new(first: nil))
      end

      it 'returns a validation error' do
        expect(subject).not_to be_valid
      end
    end

    context 'when a matching authorization is found' do
      before do
        allow(AuthorizedUser).to receive(:matching_user)
          .with(subject)
          .and_return(OpenStruct.new(first: build_stubbed(:authorized_user)))
      end

      it 'returns a validation error' do
        expect(subject).to be_valid
      end
    end
  end

  describe '#subscription_to' do
    subject { described_class.new }

    before { Lesson }

    it 'returns the subscription to the lesson' do
      lesson = instance_double('Lesson')
      subscription = instance_double('Subscription')

      expect(subject.subscriptions).to receive(:find_by)
        .with(lesson: lesson)
        .once
        .and_return(subscription)

      expect(subject.subscription_to(lesson)).to eq(subscription)
    end
  end

  describe '#subscribed_to?' do
    subject { described_class.new }

    let(:lesson) do
      lesson = instance_double('Lesson')
      allow(lesson).to receive(:id)
        .and_return(1)
      lesson
    end

    context 'when the user is subscribed to the lesson' do
      before do
        expect(subject).to receive(:subscription_to)
          .with(lesson)
          .once
          .and_return(instance_double('Subscription'))
      end

      it 'returns true' do
        expect(subject).to be_subscribed_to(lesson)
      end
    end

    context 'when the user is not subscrbed to the lesson' do
      before do
        expect(subject).to receive(:subscription_to)
          .with(lesson)
          .once
          .and_return(nil)
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

    let(:result) { described_class.with_no_subscriptions_for(frame) }

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
          organizers: [organizer_user]))
    end

    let!(:organizer_user) { FactoryGirl.create(:user) }
    let!(:not_organizer_user) { FactoryGirl.create(:user) }

    let(:result) { described_class.with_no_organized_lessons_for(frame) }

    it 'returns the users with no organized lessons to the given time frame' do
      expect(result).to include(not_organizer_user)
      expect(result).not_to include(organizer_user)
    end
  end

  describe '.with_no_occupations_for' do
    let!(:frame) { FactoryGirl.create :time_frame }
    let!(:lesson) do
      FactoryGirl.create(:lesson,
        time_frame: frame,
        course: FactoryGirl.create(:course,
          organizers: [organizer_user]))
    end

    let!(:subscribed_user) { FactoryGirl.create(:subscription, lesson: lesson).user }
    let!(:unsubscribed_user) { FactoryGirl.create(:subscription).user }

    let!(:organizer_user) { FactoryGirl.create(:user) }
    let!(:not_organizer_user) { FactoryGirl.create(:user) }

    let(:result) { described_class.with_no_occupations_for(frame) }

    it 'returns the users with no occupations to the given time frame' do
      expect(result).to include(unsubscribed_user)
      expect(result).to include(not_organizer_user)

      expect(result).not_to include(subscribed_user)
      expect(result).not_to include(organizer_user)
    end
  end
end
