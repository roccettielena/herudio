class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lesson, except: :index

  def index
    @subscriptions = current_user.subscriptions
  end

  def create
    if current_user.subscribed_to?(@lesson)
      redirect_back_or @course, alert: t('controllers.subscriptions.create.already_subscribed')
      return
    end

    if @lesson.available_seats <= 0
      redirect_back_or @course, alert: t('controllers.subscriptions.create.no_seats')
      return
    end

    if (conflicting_lesson = @lesson.conflicting_for(current_user, [:subscribed]))
      flash[:alert] = t('controllers.subscriptions.create.conflicting_with_subscribed_html',
        course_url: course_path(conflicting_lesson.course),
        course_name: ERB::Util.html_escape(conflicting_lesson.course.name)
      )

      redirect_back_or @course
      return
    end

    if (conflicting_lesson = @lesson.conflicting_for(current_user, [:organized]))
      flash[:alert] = t('controllers.subscriptions.create.conflicting_with_organized_html',
        course_url: course_path(conflicting_lesson.course),
        course_name: ERB::Util.html_escape(conflicting_lesson.course.name)
      )

      redirect_back_or @course
      return
    end

    Subscription.create!(user: current_user, lesson: @lesson)
    redirect_back_or @course, notice: t('controllers.subscriptions.create.subscribed')
  end

  def destroy
    unless current_user.subscribed_to?(@lesson)
      redirect_back_or @course, alert: t('controllers.subscriptions.destroy.not_subscribed')
      return
    end

    if @lesson.past?
      redirect_back_or @course, alert: t('controllers.subscriptions.destroy.past_lesson')
      return
    end

    current_user.subscription_to(@lesson).destroy
    redirect_back_or @course, notice: t('controllers.subscriptions.destroy.unsubscribed')
  end

  private

  def load_lesson
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
  end
end
