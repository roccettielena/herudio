# frozen_string_literal: true
class Course < ActiveRecord::Base
  scope :by_name, ->(query) { where('LOWER(name) LIKE :query', query: "%#{query}%") }
  scope :by_category, ->(category) { where(category_id: category.is_a?(CourseCategory) ? category.id : category) }

  belongs_to :category, class_name: CourseCategory, inverse_of: :courses, foreign_key: 'category_id'
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :subscriptions, through: :lessons
  has_and_belongs_to_many :organizers, class_name: 'User', inverse_of: :courses, join_table: 'courses_organizers', association_foreign_key: 'organizer_id'

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :location, presence: true
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  validate :validate_organizers

  extend Enumerize
  enumerize :status, in: [:proposed, :accepted, :rejected], predicates: true, scope: true

  scope :accepted, -> { with_status(:accepted) }

  BY_ORGANIZER_SQL = <<-SQL
    :user_id IN (
      SELECT organizer_id FROM courses_organizers WHERE course_id = courses.id
    )
  SQL

  def self.by_organizer(user)
    where(BY_ORGANIZER_SQL,
      user_id: user.is_a?(User) ? user.id : user)
  end

  def self.accessible_by(user)
    if user
      where("status = 'accepted' OR #{BY_ORGANIZER_SQL}",
        user_id: user.is_a?(User) ? user.id : user)
    else
      accepted
    end
  end

  private

  def validate_organizers
    if organizers.reject(&:marked_for_destruction?).empty?
      errors.add :organizers, :blank
    end
  end
end
