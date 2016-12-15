# frozen_string_literal: true
# @todo This must be tested.
class FillSubscriptions
  include Interactor

  ADVISORY_LOCK_NAME = 'fill_subscriptions'

  before :load_time_frame_groups

  around :with_advisory_lock

  def call
    User.all.order('RANDOM()').each do |user|
      context.time_frame_groups.each_pair do |_date, groups|
        next if groups.any? { |group| user_subscribed_to_group?(user, group) }

        availability_percentages = {}

        groups.each do |group|
          next if group.time_frames.empty?

          available_time_frames_count = group.time_frames.to_a.count do |time_frame|
            Lesson.available_for(time_frame).count.positive?
          end

          next if available_time_frames_count.zero?

          availability_percentages[group] = available_time_frames_count / group.time_frames.count
        end

        next if availability_percentages.empty?

        availability_percentages = availability_percentages.sort_by do |_group, percentage|
          percentage
        end

        group_for_subscription = availability_percentages.first[0]

        group_for_subscription.time_frames.each do |time_frame|
          next if user_subscribed_to_time_frame?(user, time_frame)

          available_lesson = Lesson.available_for(time_frame).order('RANDOM()').first
          next unless available_lesson

          user.subscriptions.create! lesson: available_lesson, origin: :system
        end
      end
    end
  end

  private

  def user_subscribed_to_group?(user, group)
    group.time_frames.all? do |time_frame|
      user_subscribed_to_time_frame?(user, time_frame)
    end
  end

  def user_subscribed_to_time_frame?(user, time_frame)
    (
      user.subscribed_lessons.where(time_frame: time_frame).count.positive? ||
      user.organized_lessons.where(time_frame: time_frame).count.positive?
    )
  end

  def load_time_frame_groups
    context.time_frame_groups = {}

    TimeFrameGroup.enabled.find_each do |time_frame_group|
      context.time_frame_groups[time_frame_group.group_date] = (
        context.time_frame_groups[time_frame_group.group_date] || []
      ) + [time_frame_group]
    end
  end

  def with_advisory_lock(interactor)
    User.with_advisory_lock(ADVISORY_LOCK_NAME) do
      interactor.call
    end
  end
end
