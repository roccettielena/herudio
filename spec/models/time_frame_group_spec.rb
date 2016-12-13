# frozen_string_literal: true
RSpec.describe TimeFrameGroup do
  subject { FactoryGirl.build(:time_frame_group) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(label group_date).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end
end
