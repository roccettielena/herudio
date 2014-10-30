class CourseDecorator < Draper::Decorator
  delegate_all

  def description_html
    h.simple_format(object.description)
  end

  def short_description_html
    h.truncate_html description_html, length: 300, omission: '...'
  end
end
