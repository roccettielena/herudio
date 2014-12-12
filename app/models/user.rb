class User < ActiveRecord::Base
  belongs_to :group, class_name: 'UserGroup', inverse_of: :users

  has_many :subscriptions, dependent: :destroy, inverse_of: :user
  has_many :subscribed_lessons, class_name: 'Lesson', through: :subscriptions, source: :lesson

  has_and_belongs_to_many :courses, inverse_of: :organizers, join_table: 'courses_organizers', foreign_key: 'organizer_id'
  has_many :organized_lessons, class_name: 'Lesson', through: :courses, source: :lessons

  devise :invitable, :database_authenticatable, :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :registerable

  validates :group, presence: true
  validates :full_name, presence: true

  scope :ordered_by_name, ->{ order('full_name ASC') }

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

    def with_no_subscriptions_for(time_frame)
      where NO_SUBSCRIPTIONS_SQL, time_frame_id: time_frame.id
    end
  end

  def subscription_to(lesson)
    subscriptions.find_by(lesson: lesson)
  end

  def subscribed_to?(lesson)
    !!subscription_to(lesson)
  end
end
