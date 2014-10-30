require 'rails_helper'

RSpec.describe Subscription do
  subject { FactoryGirl.build(:subscription) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  %w(user lesson).each do |attribute|
    it "validates the presence of #{attribute}" do
      expect(subject).to validate_presence_of(attribute)
    end
  end
end
