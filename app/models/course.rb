# frozen_string_literal: true
class Course < ActiveRecord::Base
  extend Enumerize

  belongs_to :category, class_name: CourseCategory, inverse_of: :courses, foreign_key: 'category_id'
  has_many :lessons, dependent: :destroy, inverse_of: :course
  has_many :subscriptions, through: :lessons
  has_and_belongs_to_many :organizers,
    class_name: 'User',
    inverse_of: :courses,
    join_table: 'courses_organizers',
    association_foreign_key: 'organizer_id'

  enumerize :status, in: [:proposed, :accepted, :rejected], predicates: true, scope: true

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :location, presence: true
  validates :seats, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  validate :validate_organizers

  class << self
    BY_ORGANIZER_SQL = <<-SQL
      :user_id IN (SELECT organizer_id FROM courses_organizers WHERE course_id = courses.id)
    SQL

    def by_organizer(user)
      where BY_ORGANIZER_SQL, user_id: user
    end

    def accessible_by(user)
      if user
        where "status = 'accepted' OR #{BY_ORGANIZER_SQL}", user_id: user
      else
        accepted
      end
    end

    def by_name(query)
      where 'name ILIKE :query', query: "%#{query}%"
    end

    def by_category(category)
      where category: category
    end

    def accepted
      with_status(:accepted)
    end
  end

  private

  def validate_organizers
    return if organizers.reject(&:marked_for_destruction?).any?
    errors.add :organizers, :blank
  end
end
