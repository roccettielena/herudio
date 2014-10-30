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

  it 'validates the uniqueness of lesson (scoped to user)' do
    subscription = FactoryGirl.create(:subscription)

    expect(FactoryGirl.build(:subscription,
      user: subscription.user
    )).to be_valid

    expect(FactoryGirl.build(:subscription,
      lesson: subscription.lesson
    )).to be_valid

    expect(FactoryGirl.build(:subscription,
      user: subscription.user,
      lesson: subscription.lesson
    )).not_to be_valid
  end
end
