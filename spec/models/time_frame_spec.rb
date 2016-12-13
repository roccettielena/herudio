# frozen_string_literal: true
require 'rails_helper'

RSpec.describe TimeFrame do
  subject { FactoryGirl.build_stubbed(:time_frame) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(starts_at ends_at group).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  it 'validates ends_at is after starts_at' do
    expect(FactoryGirl.build_stubbed(:time_frame,
      starts_at: Time.zone.now,
      ends_at: Time.zone.now - 1.hour)).not_to be_valid
  end

  it "validates starts_at belongs to the group's date" do
    expect(FactoryGirl.build_stubbed(:time_frame,
      starts_at: Time.zone.yesterday)).not_to be_valid
  end

  it "validates ends_at belongs to the group's date" do
    expect(FactoryGirl.build_stubbed(:time_frame,
      ends_at: Time.zone.tomorrow)).not_to be_valid
  end
end
