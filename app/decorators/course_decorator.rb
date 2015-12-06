class CourseDecorator < Draper::Decorator
  delegate_all

  decorates_association :lessons

  def description_html
    h.simple_format(object.description)
  end

  def short_description_html
    h.truncate_html description_html, length: 300, omission: '...'
  end

  def status
    if object.status.proposed?
      label_class = 'label-info'
    elsif object.status.accepted?
      label_class = 'label-success'
    elsif obejct.status.rejected?
      label_class = 'label-danger'
    end

    h.content_tag(:span, object.status.text, class: "label #{label_class}")
  end
end
