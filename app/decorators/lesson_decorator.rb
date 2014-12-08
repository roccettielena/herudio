class LessonDecorator < Draper::Decorator
  delegate_all

  decorates_association :time_frame

  def starts_at
    time_frame.starts_at
  end

  def ends_at
    time_frame.starts_at
  end

  def to_s
    "#{starts_at} - #{ends_at}"
  end
end
