# frozen_string_literal: true
class TimeFrame < ActiveRecord::Base
  has_many :lessons, inverse_of: :time_frame, dependent: :restrict_with_exception

  validates :starts_at, presence: true, date: { before: :ends_at }
  validates :ends_at, presence: true, date: { after: :starts_at }

  just_define_datetime_picker :starts_at
  just_define_datetime_picker :ends_at
end
