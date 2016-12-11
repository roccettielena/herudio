# frozen_string_literal: true
class User < ActiveRecord::Base
  belongs_to :group, class_name: 'UserGroup', inverse_of: :users

  has_many :subscriptions, dependent: :destroy, inverse_of: :user
  has_many :subscribed_lessons, class_name: 'Lesson', through: :subscriptions, source: :lesson

  has_and_belongs_to_many :courses,
    inverse_of: :organizers,
    join_table: 'courses_organizers',
    foreign_key: 'organizer_id'

  has_many :organized_lessons, class_name: 'Lesson', through: :courses, source: :lessons

  devise(
    :invitable, :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable,
    :validatable, :registerable, :async
  )

  validates :group, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birth_date, presence: true, date: true
  validates :birth_location, presence: true

  validate :validate_user_authorization, if: -> {
    new_record? && ENV.fetch('REGISTRATION_TYPE') == 'regular'
  }

  scope :ordered_by_name, -> { order('full_name ASC') }

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_s
    "#{full_name} (#{group.name})"
  end

  class << self
    NO_SUBSCRIPTIONS_SQL = <<-SQL
      (
        SELECT COUNT(subscriptions.*)
        FROM subscriptions, lessons
        WHERE
          subscriptions.user_id = users.id
          AND subscriptions.lesson_id = lessons.id
          AND lessons.time_frame_id = :time_frame_id
      ) = 0
    SQL

    NO_ORGANIZED_LESSONS_SQL = <<-SQL
      (
        SELECT COUNT(lessons.*)
        FROM lessons
        INNER JOIN courses
          ON lessons.course_id = courses.id
        INNER JOIN courses_organizers
          ON courses.id = courses_organizers.course_id
        WHERE
          courses_organizers.organizer_id = users.id
          AND lessons.time_frame_id = :time_frame_id
      ) = 0
    SQL

    def with_no_subscriptions_for(time_frame)
      where NO_SUBSCRIPTIONS_SQL, time_frame_id: time_frame.id
    end

    def with_no_organized_lessons_for(time_frame)
      where NO_ORGANIZED_LESSONS_SQL, time_frame_id: time_frame.id
    end

    def with_no_occupations_for(time_frame)
      with_no_subscriptions_for(time_frame).with_no_organized_lessons_for(time_frame)
    end
  end

  def subscription_to(lesson)
    subscriptions.find_by(lesson: lesson)
  end

  def subscribed_to?(lesson)
    !!subscription_to(lesson)
  end

  def skip_authorized_user_validation
    @skip_authorized_user_validation = true
  end

  def skip_authorized_user_validation?
    @skip_authorized_user_validation
  end

  private

  def validate_user_authorization
    return if @skip_authorized_user_validation

    return unless first_name.present?
    return unless last_name.present?
    return unless birth_location.present?
    return unless birth_date.present?
    return unless group_id.present?

    return if AuthorizedUser.matching_user(self).exists?

    errors.add :base, 'Le informazioni che hai inserito non corrispondono a uno studente valido.'
  end
end
