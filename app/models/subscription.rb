# frozen_string_literal: true
class Subscription < ActiveRecord::Base
  extend Enumerize

  enumerize :origin, in: %w(manual admin system)

  belongs_to :user, inverse_of: :subscriptions
  belongs_to :lesson, inverse_of: :subscriptions

  validates :user, presence: true
  validates :lesson, presence: true, uniqueness: { scope: :user }

  class << self
    def open?
      now = Time.zone.now

      opening_time = ENV['SUBSCRIPTIONS_OPEN_AT']
      closing_time = ENV['SUBSCRIPTIONS_CLOSE_AT']

      opening_time = (now - 1.hour) if opening_time.blank?
      closing_time = (now + 1.hour) if closing_time.blank?

      now >= opening_time && now <= closing_time
    end

    def closed?
      !open?
    end
  end

  delegate :course, to: :lesson
end
