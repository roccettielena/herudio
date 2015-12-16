class SubscriptionFillingService
  def fill_subscriptions_for(time_frame)
    User.with_no_occupations_for(time_frame).find_each do |user|
      lessons = Lesson.available_for(time_frame)

      if lessons.empty?
        raise NoLessonsError, "No lessons with available seats in time frame ##{time_frame.id}"
        return
      end

      user.subscriptions.create! lesson: lessons.first
    end
  end

  class NoLessonsError < StandardError
  end
end
