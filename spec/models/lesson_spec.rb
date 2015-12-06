require 'rails_helper'

RSpec.describe Lesson do
  subject { FactoryGirl.build(:lesson) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(course).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  it 'validates it is not in conflict with other lessons of the course' do
    conflicting_lesson = Lesson.new

    course = Course.new
    allow(course).to receive(:lessons)
      .and_return([conflicting_lesson])

    lesson = FactoryGirl.build(:lesson, course: course)

    expect(lesson).to receive(:in_conflict_with?)
      .with(conflicting_lesson)
      .once
      .and_return(true)

    expect(lesson).not_to be_valid
  end

  describe '#past?' do
    context 'when the lesson is past' do
      subject do
        FactoryGirl.build_stubbed(:lesson,
          time_frame: FactoryGirl.build_stubbed(:time_frame,
            ends_at: Date.yesterday
          )
        )
      end

      it 'returns true' do
        expect(subject).to be_past
      end
    end

    context 'when the lesson is not past' do
      subject do
        FactoryGirl.build_stubbed(:lesson,
          time_frame: FactoryGirl.build_stubbed(:time_frame,
            ends_at: Date.tomorrow
          )
        )
      end

      it 'returns false' do
        expect(subject).not_to be_past
      end
    end
  end

  describe '#seats' do
    before(:each) do
      allow(subject.course).to receive(:seats)
        .and_return(30)
    end

    it 'returns Course#seats' do
      expect(subject.seats).to eq(30)
    end
  end

  describe '#taken_seats' do
    before(:each) do
      allow(subject.subscriptions).to receive(:count)
        .and_return(13)
    end

    it 'returns the number of taken seats' do
      expect(subject.taken_seats).to eq(13)
    end
  end

  describe '#available_seats' do
    before(:each) do
      allow(subject).to receive(:seats)
        .and_return(30)

      allow(subject).to receive(:taken_seats)
        .and_return(17)
    end

    it 'returns the number of available seats' do
      expect(subject.available_seats).to eq(13)
    end
  end

  describe '#in_conflict_with?' do
    subject do
      FactoryGirl.build_stubbed(:lesson,
        time_frame: FactoryGirl.build_stubbed(:time_frame,
          starts_at: Time.now,
          ends_at: Time.now + 1.hour
        )
      )
    end

    context 'when the lessons overlap' do
      let(:lesson) do
        FactoryGirl.build_stubbed(:lesson,
          time_frame: FactoryGirl.build_stubbed(:time_frame,
            starts_at: Time.now + 30.minutes,
            ends_at: Time.now + 90.minutes
          )
        )
      end

      it 'returns true' do
        expect(subject).to be_in_conflict_with(lesson)
      end
    end

    context "when the lessons don't overlap" do
      let(:lesson) do
        FactoryGirl.build_stubbed(:lesson,
          time_frame: FactoryGirl.build_stubbed(:time_frame,
            starts_at: Time.now + 61.minutes,
            ends_at: Time.now + 121.minutes
          )
        )
      end

      it 'returns false' do
        expect(subject).not_to be_in_conflict_with(lesson)
      end
    end
  end

  describe '#conflicting_for' do
    let(:user) { instance_double('User') }

    let(:conflicting_lesson) { instance_double('Lesson') }
    let(:compatible_lesson) { instance_double('Lesson') }

    context 'when the user has conflicting lessons' do
      before do
        allow(user).to receive(:subscribed_lessons)
          .and_return([compatible_lesson, conflicting_lesson])

        allow(subject).to receive(:in_conflict_with?)
          .with(compatible_lesson)
          .and_return(false)

        allow(subject).to receive(:in_conflict_with?)
          .with(conflicting_lesson)
          .and_return(true)
      end

      it 'returns the conflicting lesson' do
        expect(subject.conflicting_for(user, [:subscribed])).to eq(conflicting_lesson)
      end
    end

    context 'when the user has no conflicting lessons' do
      before do
        allow(user).to receive(:subscribed_lessons)
          .and_return([compatible_lesson])

        allow(user).to receive(:organized_lessons)
          .and_return([compatible_lesson])

        allow(subject).to receive(:in_conflict_with?)
          .with(compatible_lesson)
          .and_return(false)
      end

      it 'returns nil' do
        expect(subject.conflicting_for(user)).to be_nil
      end
    end

    context 'when an invalid association is specified' do
      it 'raises an error' do
        expect {
          subject.conflicting_for?(user, [:organized, :foo])
        }.to raise_error(Lesson::InvalidAssociationError)
      end
    end
  end

  describe '.available' do
    it 'returns the available lessons' do
      available_lesson = FactoryGirl.create(:lesson,
        course: FactoryGirl.create(:course,
          seats: 1
        )
      )

      unavailable_lesson = FactoryGirl.create(:lesson,
        course: FactoryGirl.create(:course,
          seats: 1
        )
      )

      FactoryGirl.create(:subscription, lesson: unavailable_lesson)

      expect(Lesson.available).to eq([available_lesson])
    end
  end

  describe '.available_for' do
    it 'returns the available lessons in the given time frame' do
      frame = FactoryGirl.build_stubbed(:time_frame)
      scope = OpenStruct.new(available: [])

      allow(Lesson).to receive(:where)
        .with(time_frame: frame)
        .and_return(scope)

      Lesson.available_for(frame)
    end
  end
end
