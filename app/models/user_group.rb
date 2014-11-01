class UserGroup < ActiveRecord::Base
  has_many :users, dependent: :restrict_with_error, inverse_of: :group

  validates :name, presence: true, uniqueness: true

  def to_s
    name
  end
end
