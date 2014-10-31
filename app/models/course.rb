class Course < ActiveRecord::Base
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_and_belongs_to_many :organizers, class_name: 'User', inverse_of: :courses, join_table: 'courses_organizers', association_foreign_key: 'organizer_id'

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :location, presence: true
  validates :seats, presence: true, numericality: { greater_than: 0 }
end
