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
end
