class Course < ActiveRecord::Base
  scope :by_name, ->(query) { where('LOWER(name) LIKE :query', query: "%#{query}%") }
  scope :by_category, ->(category) { where(category_id: category.is_a?(CourseCategory) ? category.id : category) }

  belongs_to :category, class_name: CourseCategory, inverse_of: :courses, foreign_key: 'category_id'
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :subscriptions, through: :lessons
  has_and_belongs_to_many :organizers, class_name: 'User', inverse_of: :courses, join_table: 'courses_organizers', association_foreign_key: 'organizer_id'

  accepts_nested_attributes_for :lessons, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :location, presence: true
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true
end
