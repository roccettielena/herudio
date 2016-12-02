# frozen_string_literal: true
class UserDecorator < Draper::Decorator
  delegate_all

  decorates_association :courses
  decorates_association :subscriptions
end
