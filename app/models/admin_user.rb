# frozen_string_literal: true
class AdminUser < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :async

  validates :full_name, presence: true
end
