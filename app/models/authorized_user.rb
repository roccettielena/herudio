class AuthorizedUser < ActiveRecord::Base
  belongs_to :group, class_name: 'UserGroup', inverse_of: :authorized_users

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :group, presence: true
  validates :birth_location, presence: true
  validates :birth_date, presence: true, date: true

  def to_s
    "#{first_name} #{last_name}"
  end
end
