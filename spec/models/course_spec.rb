require 'rails_helper'

RSpec.describe Course do
  subject { FactoryGirl.build(:course) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(name description).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end

  it 'validates the presence of name' do
    FactoryGirl.create(:course)
    expect(subject).to validate_uniqueness_of(:name)
  end
end
