# frozen_string_literal: true
class UserGroup < ActiveRecord::Base
  has_many :users, dependent: :restrict_with_exception, inverse_of: :group, foreign_key: 'group_id'
  has_many :authorized_users, inverse_of: :group, foreign_key: 'group_id'

  validates :name, presence: true, uniqueness: true

  scope :ordered_by_name, -> { order('name ASC') }

  def to_s
    name
  end
end
