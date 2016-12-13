# frozen_string_literal: true
class AuthorizedUser < ActiveRecord::Base
  belongs_to :group, class_name: 'UserGroup', inverse_of: :authorized_users
  has_one :user, inverse_of: :authorized_user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :group, presence: true
  validates :birth_location, presence: true
  validates :birth_date, presence: true, date: true

  class << self
    def matching_user(user)
      sql = <<~SQL
        TRIM(LOWER(first_name)) = :first_name AND
        TRIM(LOWER(last_name)) = :last_name AND
        TRIM(LOWER(birth_location)) = :birth_location AND
        birth_date = :birth_date AND
        group_id = :group_id
      SQL

      where sql,
        first_name: user.first_name.downcase.strip,
        last_name: user.last_name.downcase.strip,
        birth_location: user.birth_location.downcase.strip,
        birth_date: user.birth_date,
        group_id: user.group_id
    end
  end

  def to_s
    "#{first_name} #{last_name}"
  end
end
