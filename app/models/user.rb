class User < ActiveRecord::Base
  belongs_to :group, inverse_of: :users

  devise :database_authenticatable, :confirmable, :recoverable, :rememberable,
         :trackable, :validatable, :registerable

  validates :group, presence: true
  validates :full_name, presence: true
end
