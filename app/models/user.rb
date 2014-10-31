class User < ActiveRecord::Base
  belongs_to :group, inverse_of: :users

  has_many :subscriptions, dependent: :destroy, inverse_of: :user
  has_many :lessons, through: :subscriptions

  has_and_belongs_to_many :courses, inverse_of: :organizers, join_table: 'courses_organizers', foreign_key: 'organizer_id'

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :registerable

  validates :group, presence: true
  validates :full_name, presence: true

  def subscription_to(lesson)
    subscriptions.find_by(lesson: lesson)
  end

  def subscribed_to?(lesson)
    !!subscription_to(lesson)
  end
end
