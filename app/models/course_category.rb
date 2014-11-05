class CourseCategory < ActiveRecord::Base
  has_many :courses, dependent: :restrict_with_error, inverse_of: :category, foreign_key: 'category_id'

  validates :name, presence: true, uniqueness: true
end
