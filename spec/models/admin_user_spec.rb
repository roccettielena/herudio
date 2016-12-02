# frozen_string_literal: true
require 'rails_helper'

RSpec.describe AdminUser do
  subject { FactoryGirl.build(:admin_user) }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'validates the presence of full_name' do
    expect(subject).to validate_presence_of(:full_name)
  end
end
