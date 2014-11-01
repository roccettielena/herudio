require 'rails_helper'

RSpec.describe Lesson do
  subject { FactoryGirl.build(:lesson) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(course starts_at ends_at).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  it 'validates ends_at is after starts_at' do
    expect(FactoryGirl.build(:lesson,
      starts_at: Time.now,
      ends_at: Time.now - 1.hour
    )).not_to be_valid
  end

  describe '#seats' do
    before(:each) do
      subject
        .course
        .expects(:seats)
        .once
        .returns(30)
    end

    it 'returns Course#seats' do
      expect(subject.seats).to eq(30)
    end
  end

  describe '#taken_seats' do
    before(:each) do
      subject
        .subscriptions
        .expects(:count)
        .once
        .returns(13)
    end

    it 'returns the number of taken seats' do
      expect(subject.taken_seats).to eq(13)
    end
  end

  describe '#available_seats' do
    before(:each) do
      subject
        .expects(:seats)
        .once
        .returns(30)

      subject
        .expects(:taken_seats)
        .once
        .returns(17)
    end

    it 'returns the number of available seats' do
      expect(subject.available_seats).to eq(13)
    end
  end

  describe '#overlaps_with?' do
    subject do
      FactoryGirl.build(:lesson,
        starts_at: Time.now,
        ends_at: Time.now + 1.hour
      )
    end

    context 'when the lessons overlap' do
      let(:lesson) do
        FactoryGirl.build(:lesson,
          starts_at: Time.now + 30.minutes,
          ends_at: Time.now + 90.minutes
        )
      end

      it 'returns true' do
        expect(subject).to be_in_conflict_with(lesson)
      end
    end

    context "when the lessons don't overlap" do
      let(:lesson) do
        FactoryGirl.build(:lesson,
          starts_at: Time.now + 61.minutes,
          ends_at: Time.now + 121.minutes
        )
      end

      it 'returns false' do
        expect(subject).not_to be_in_conflict_with(lesson)
      end
    end
  end

  describe '#conflicting_for?' do
    let(:user) { stub() }

    context 'when the user has conflicting lessons' do
      before do
        conflicting_lesson = stub()
        compatible_lesson = stub()

        user
          .expects(:subscribed_lessons)
          .once
          .returns([compatible_lesson, conflicting_lesson])

        subject
          .expects(:in_conflict_with?)
          .with(compatible_lesson)
          .once
          .returns(false)

        subject
          .expects(:in_conflict_with?)
          .with(conflicting_lesson)
          .once
          .returns(true)
      end

      it 'returns true' do
        expect(subject).to be_conflicting_for(user, [:subscribed])
      end
    end

    context 'when the user has no conflicting lessons' do
      before do
        compatible_lesson = stub()

        user
          .expects(:subscribed_lessons)
          .once
          .returns([compatible_lesson])

        user
          .expects(:organized_lessons)
          .once
          .returns([compatible_lesson])

        subject
          .expects(:in_conflict_with?)
          .with(compatible_lesson)
          .twice
          .returns(false)
      end

      it 'returns false' do
        expect(subject).not_to be_conflicting_for(user)
      end
    end

    context 'when an invalid association is specified' do
      it 'raises an error' do
        expect {
          subject.conflicting_for?(user, [:organized, :foo])
        }.to raise_error
      end
    end
  end
end
