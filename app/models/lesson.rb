class Lesson < ActiveRecord::Base
  belongs_to :course, inverse_of: :lessons
  has_many :subscriptions, dependent: :destroy, inverse_of: :lesson

  validates :course, presence: true
  validates :starts_at, presence: true, date: { before: :ends_at }
  validates :ends_at, presence: true, date: { after: :starts_at }
end
