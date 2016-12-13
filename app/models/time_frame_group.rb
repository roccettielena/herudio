# frozen_string_literal: true
class TimeFrameGroup < ActiveRecord::Base
  has_many :time_frames, inverse_of: :group, foreign_key: :group_id

  validates :label, presence: true, uniqueness: true
  validates :group_date, presence: true

  def to_s
    label
  end
end
