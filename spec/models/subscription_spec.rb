# frozen_string_literal: true
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
      user: subscription.user)).to be_valid

    expect(FactoryGirl.build(:subscription,
      lesson: subscription.lesson)).to be_valid

    expect(FactoryGirl.build(:subscription,
      user: subscription.user,
      lesson: subscription.lesson)).not_to be_valid
  end

  describe '.open?' do
    after do
      ENV.delete('SUBSCRIPTIONS_OPEN_AT')
      ENV.delete('SUBSCRIPTIONS_CLOSE_AT')
    end

    context 'when there is no opening or closing time' do
      before do
        ENV.delete('SUBSCRIPTIONS_OPEN_AT')
        ENV.delete('SUBSCRIPTIONS_CLOSE_AT')
      end

      it 'returns true' do
        expect(described_class).to be_open
      end
    end

    context 'when it is before the opening time' do
      before do
        ENV['SUBSCRIPTIONS_OPEN_AT'] = Date.tomorrow.to_s
        ENV['SUBSCRIPTIONS_CLOSE_AT'] = (Date.tomorrow + 1.day).to_s
      end

      it 'returns false' do
        expect(described_class).not_to be_open
      end
    end

    context 'when it is after the closing time' do
      before do
        ENV['SUBSCRIPTIONS_OPEN_AT'] = (Date.yesterday - 1.day).to_s
        ENV['SUBSCRIPTIONS_CLOSE_AT'] = Date.yesterday.to_s
      end

      it 'returns false' do
        expect(described_class).not_to be_open
      end
    end

    context 'when it is within the opening and the closing time' do
      before do
        ENV['SUBSCRIPTIONS_OPEN_AT'] = Date.yesterday.to_s
        ENV['SUBSCRIPTIONS_CLOSE_AT'] = Date.tomorrow.to_s
      end

      it 'returns true' do
        expect(described_class).to be_open
      end
    end
  end
end
