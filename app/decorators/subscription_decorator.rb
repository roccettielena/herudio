# frozen_string_literal: true
class SubscriptionDecorator < Draper::Decorator
  delegate_all

  decorates_association :lesson
end
