module SubscriptionsHelper
  def subscription_link(user, lesson, options = {})
    if user.subscribed_to?(lesson)
      unsubscribe_link(user, lesson, options)
    else
      subscribe_link(user, lesson, options)
    end
  end

  protected

  def subscribe_link(user, lesson, options = {})
    text = fa_icon('plus')
    text += ' ' + t('controllers.courses.show.lessons.subscribe')

    href = course_lesson_subscription_path(lesson.course, lesson)

    options = { class: 'btn btn-sm btn-primary' }.merge(options)
    options = options.merge(
      method: :post,
      disabled: (lesson.available_seats <= 0 || lesson.conflicting_for?(user))
    )

    link_to text, href, options
  end

  def unsubscribe_link(user, lesson, options = {})
    text = fa_icon('trash')
    text += ' ' + t('controllers.courses.show.lessons.unsubscribe')

    href = course_lesson_subscription_path(lesson.course, lesson)

    options = { class: 'btn btn-sm btn-danger' }.merge(options)
    options = options.merge(method: :delete)

    link_to text, href, options
  end
end
