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
    text += ' ' + t('helpers.subscriptions.subscribe')

    href = course_lesson_subscription_path(lesson.course, lesson)

    options = { class: 'btn btn-sm btn-primary' }.merge(options)
    options = options.merge(
      method: :post,
      disabled: (lesson.available_seats <= 0 || lesson.conflicting_for?(user))
    )

    output = [link_to(text, href, options)]

    conflict_message = conflict_message_for(user, lesson, options)

    if conflict_message
      output << fa_icon('question-circle', class: 'fa-fw text-danger', data: { toggle: 'tooltip' }, title: conflict_message)
    end

    output.join("\n").html_safe
  end

  def unsubscribe_link(user, lesson, options = {})
    text = fa_icon('trash')
    text += ' ' + t('helpers.subscriptions.unsubscribe')

    href = course_lesson_subscription_path(lesson.course, lesson)

    options = { class: 'btn btn-sm btn-danger' }.merge(options)
    options = options.merge(
      method:   :delete,
      disabled: lesson.past?
    )

    output = [link_to(text, href, options)]

    output.join("\n").html_safe
  end

  private

  def conflict_message_for(user, lesson, options = {})
    conflict_message = nil

    if (conflicting_lesson = lesson.conflicting_for(user, [:subscribed]))
      conflict_message = t('helpers.subscriptions.conflicting_with_subscribed',
        course_name: conflicting_lesson.course.name
      )
    elsif (conflicting_lesson = lesson.conflicting_for(user, [:organized]))
      conflict_message = t('helpers.subscriptions.conflicting_with_organized',
        course_name: conflicting_lesson.course.name
      )
    end

    conflict_message
  end
end
