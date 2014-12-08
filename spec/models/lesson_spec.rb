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
    course.stubs(lessons: [conflicting_lesson])

    lesson = FactoryGirl.build(:lesson, course: course)

    lesson
      .expects(:in_conflict_with?)
      .with(conflicting_lesson)
      .once
      .returns(true)

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
    let(:user) { stub() }

    let(:conflicting_lesson) { stub() }
    let(:compatible_lesson) { stub() }

    context 'when the user has conflicting lessons' do
      before do
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

      it 'returns the conflicting lesson' do
        expect(subject.conflicting_for(user, [:subscribed])).to eq(conflicting_lesson)
      end
    end

    context 'when the user has no conflicting lessons' do
      before do
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

      it 'returns nil' do
        expect(subject.conflicting_for(user)).to be_nil
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
      scope = stub()

      Lesson
        .expects(:where)
        .with(time_frame: frame)
        .once
        .returns(scope)

      scope
        .expects(:available)
        .once

      Lesson.available_for(frame)
    end
  end
end
