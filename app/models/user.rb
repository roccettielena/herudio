# frozen_string_literal: true
class User < ActiveRecord::Base
  belongs_to :group, class_name: 'UserGroup', inverse_of: :users
  belongs_to :authorized_user, inverse_of: :user
  has_many :subscriptions, dependent: :destroy, inverse_of: :user
  has_many :subscribed_lessons, class_name: 'Lesson', through: :subscriptions, source: :lesson

  has_and_belongs_to_many :courses,
    inverse_of: :organizers,
    join_table: 'courses_organizers',
    foreign_key: 'organizer_id'

  has_many :organized_lessons,
    -> { joins(:course).merge(Course.accepted) },
    class_name: 'Lesson',
    through: :courses,
    source: :lessons

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
  validate :validate_user_authorization_uniqueness, if: -> {
    new_record? && ENV.fetch('REGISTRATION_TYPE') == 'regular'
  }

  before_create :set_authorized_user, if: -> {
    new_record? && ENV.fetch('REGISTRATION_TYPE') == 'regular'
  }

  def full_name
    "#{last_name} #{first_name}"
  end

  def to_s
    "#{full_name} (#{group.name})"
  end

  class << self
    NO_SUBSCRIPTIONS_SQL = <<-SQL
      (
        SELECT COUNT(subscriptions.*)
        FROM subscriptions, lessons, courses
        WHERE
          subscriptions.user_id = users.id
          AND subscriptions.lesson_id = lessons.id
          AND lessons.course_id = courses.id
          AND courses.status = 'accepted'
          AND lessons.time_frame_id IN(:time_frame_ids)
      ) = 0
    SQL

    NO_ORGANIZED_LESSONS_SQL = <<-SQL
      (
        SELECT COUNT(lessons.*)
        FROM lessons
        INNER JOIN courses
          ON lessons.course_id = courses.id
          AND courses.status = 'accepted'
        INNER JOIN courses_organizers
          ON courses.id = courses_organizers.course_id
        WHERE
          courses_organizers.organizer_id = users.id
          AND lessons.time_frame_id IN(:time_frame_ids)
      ) = 0
    SQL

    def with_no_subscriptions_for(time_frames)
      time_frames = [time_frames].flatten
      where NO_SUBSCRIPTIONS_SQL, time_frame_ids: time_frames.map(&:id)
    end

    def with_no_organized_lessons_for(time_frames)
      time_frames = [time_frames].flatten
      where NO_ORGANIZED_LESSONS_SQL, time_frame_ids: time_frames.map(&:id)
    end

    def with_no_occupations_for(time_frames)
      with_no_subscriptions_for(time_frames).with_no_organized_lessons_for(time_frames)
    end

    def ordered_by_name
      order('last_name ASC, first_name ASC')
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

  def load_authorized_user
    AuthorizedUser.matching_user(self).first
  end

  def set_authorized_user
    self.authorized_user = load_authorized_user
  end

  def validate_user_authorization
    return if @skip_authorized_user_validation

    return unless first_name.present?
    return unless last_name.present?
    return unless birth_location.present?
    return unless birth_date.present?
    return unless group_id.present?

    return if load_authorized_user

    errors.add :base, 'Le informazioni che hai inserito non corrispondono a uno studente valido.'
  end

  def validate_user_authorization_uniqueness
    return if @skip_authorized_user_validation
    return unless load_authorized_user&.user

    errors.add :base, 'Questo utente è già registrato alla piattaforma.'
  end
end
