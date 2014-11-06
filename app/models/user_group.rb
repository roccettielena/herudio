class UserGroup < ActiveRecord::Base
  has_many :users, dependent: :restrict_with_exception, inverse_of: :group, foreign_key: 'group_id'

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
