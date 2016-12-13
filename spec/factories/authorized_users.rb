# frozen_string_literal: true
FactoryGirl.define do
  factory :authorized_user do
    first_name 'MyString'
    last_name 'MyString'
    group_id 1
    birth_location 'MyString'
    birth_date '2016-12-09'
  end
end
