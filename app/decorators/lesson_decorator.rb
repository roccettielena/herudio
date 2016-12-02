# frozen_string_literal: true
class LessonDecorator < Draper::Decorator
  delegate_all

  decorates_association :time_frame

  delegate :starts_at, to: :time_frame

  delegate :ends_at, to: :time_frame

  def to_s
    "#{starts_at} - #{ends_at}"
  end
end
