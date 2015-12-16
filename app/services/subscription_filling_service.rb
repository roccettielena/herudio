class SubscriptionFillingService
  def fill_subscriptions_for(time_frame)
    User.with_no_occupations_for(time_frame).find_each do |user|
      lessons = Lesson.available_for(time_frame)
      return if lessons.empty?

      user.subscriptions.create! lesson: lessons.first
    end
  end

  class NoLessonsError < StandardError
  end
end
