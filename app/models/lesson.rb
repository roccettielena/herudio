class Lesson < ActiveRecord::Base
  belongs_to :course, inverse_of: :lessons
  belongs_to :time_frame, inverse_of: :lessons

  has_many :subscriptions, dependent: :destroy, inverse_of: :lesson

  validates :course, presence: true
  validates :time_frame, presence: true

  validate :validate_conflicts_in_course

  delegate :starts_at, :ends_at, to: :time_frame, allow_nil: true

  class << self
    AVAILABLE_SQL = <<-SQL
      (
        (
          SELECT courses.seats
          FROM courses
          WHERE courses.id = lessons.course_id
        )
        -
        (
          SELECT COUNT(subscriptions.id)
          FROM subscriptions
          WHERE subscriptions.lesson_id = lessons.id
        )
      ) > 0
    SQL

    def available
      where(AVAILABLE_SQL)
    end

    def available_for(time_frame)
      where(time_frame: time_frame).available
    end
  end

  def to_s
    "Lezione ##{id}"
  end

  def seats
    course.seats
  end

  def taken_seats
    subscriptions.count
  end

  def available_seats
    seats - taken_seats
  end

  def past?
    ends_at <= Time.now
  end

  def in_conflict_with?(lesson)
    (starts_at <= lesson.ends_at) && (ends_at >= lesson.starts_at)
  end

  def conflicting_for(user, associations = [:subscribed, :organized])
    raise InvalidAssociationError, 'Invalid association(s) specified' if associations.select do |a|
      !a.try(:to_sym).in?([:subscribed, :organized])
    end.any?

    associations.any? do |association|
      user.send("#{association}_lessons").any? do |lesson|
        return lesson if in_conflict_with?(lesson)
      end
    end

    nil
  end

  def conflicting_for?(user, associations = [:subscribed, :organized])
    !!conflicting_for(user, associations)
  end

  private

  def validate_conflicts_in_course
    return unless course

    course.lessons.reject{ |l| l == self }.each do |lesson|
      if in_conflict_with?(lesson)
        errors.add :starts_at, :in_conflict
        errors.add :ends_at, :in_conflict

        return
      end
    end
  end

  class InvalidAssociationError < RuntimeError
  end
end
