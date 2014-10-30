class LessonDecorator < Draper::Decorator
  delegate_all

  def starts_at
    h.l object.starts_at, format: :long
  end

  def ends_at
    h.l object.ends_at, format: :long
  end
end
