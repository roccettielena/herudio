class Course < ActiveRecord::Base
  has_many :lessons, dependent: :destroy, inverse_of: :course

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :location, presence: true
end
