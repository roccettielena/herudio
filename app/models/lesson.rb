class Lesson < ActiveRecord::Base
  belongs_to :course, inverse_of: :lessons
  has_many :subscriptions, dependent: :destroy, inverse_of: :lesson

  validates :course, presence: true
  validates :starts_at, presence: true, date: { before: :ends_at }
  validates :ends_at, presence: true, date: { after: :starts_at }

  just_define_datetime_picker :starts_at
  just_define_datetime_picker :ends_at

  validate :validate_conflicts_in_course

  def seats
    course.seats
  end

  def taken_seats
    subscriptions.count
  end

  def available_seats
    seats - taken_seats
  end

  def in_conflict_with?(lesson)
    (starts_at <= lesson.ends_at) && (ends_at >= lesson.starts_at)
  end

  def conflicting_for(user, associations = [:subscribed, :organized])
    raise 'Invalid association(s) specified' if associations.select do |a|
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

    course.lessons.each do |lesson|
      if in_conflict_with?(lesson)
        errors.add :starts_at, :in_conflict
        errors.add :ends_at, :in_conflict

        return
      end
    end
  end
end
