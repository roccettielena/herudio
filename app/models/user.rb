class User < ActiveRecord::Base
  belongs_to :group, inverse_of: :users
  has_many :subscriptions, dependent: :destroy, inverse_of: :user

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
