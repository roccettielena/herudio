class CourseCategory < ActiveRecord::Base
  has_many :courses, dependent: :restrict_with_error, inverse_of: :category

  validates :name, presence: true, uniqueness: true
end
