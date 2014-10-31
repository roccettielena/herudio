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
end
