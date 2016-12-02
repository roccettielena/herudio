# frozen_string_literal: true
class CourseCategory < ActiveRecord::Base
  has_many :courses, dependent: :restrict_with_exception, inverse_of: :category, foreign_key: 'category_id'

  validates :name, presence: true, uniqueness: true
end
