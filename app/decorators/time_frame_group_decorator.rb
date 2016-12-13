# frozen_string_literal: true
class TimeFrameGroupDecorator < Draper::Decorator
  delegate_all

  decorates_association :time_frames

  def group_date
    h.l object.group_date, format: :long
  end
end
