class TimeFrameDecorator < Draper::Decorator
  delegate_all

  def starts_at
    h.l object.starts_at, format: :long
  end

  def ends_at
    h.l object.ends_at, format: :long
  end

  def to_s
    "#{starts_at} - #{ends_at}"
  end
end
