class Subscription < ActiveRecord::Base
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :lesson, inverse_of: :subscriptions

  validates :user, presence: true
  validates :lesson, presence: true, uniqueness: { scope: :user }
end
