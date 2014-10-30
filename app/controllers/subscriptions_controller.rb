class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_lesson

  def create
    if current_user.subscribed_to?(@lesson)
      redirect_to @course, alert: t('controllers.subscriptions.create.already_subscribed')
      return
    end

    Subscription.create!(user: current_user, lesson: @lesson)
    redirect_to @course, notice: t('controllers.subscriptions.create.subscribed')
  end

  def destroy
    unless current_user.subscribed_to?(@lesson)
      redirect_to @course, alert: t('controllers.subscriptions.destroy.not_subscribed')
      return
    end

    current_user.subscription_to(@lesson).destroy
    redirect_to @course, notice: t('controllers.subscriptions.destroy.unsubscribed')
  end

  private

  def load_lesson
    @course = Course.find(params[:course_id])
    @lesson = @course.lessons.find(params[:lesson_id])
  end
end
