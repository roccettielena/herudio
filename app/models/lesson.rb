class Lesson < ActiveRecord::Base
  belongs_to :course, inverse_of: :lessons

  validates :course, presence: true
  validates :starts_at, presence: true, date: { before: :ends_at }
  validates :ends_at, presence: true, date: { after: :starts_at }
end
