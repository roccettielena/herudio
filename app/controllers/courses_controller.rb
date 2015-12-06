class CoursesController < ApplicationController
  has_scope :by_name
  has_scope :by_category

  decorates_assigned :course

  before_action :authenticate_user!, only: [:new, :create]

  def index
    @courses = apply_scopes(Course.accessible_by(current_user)).paginate(
      page: params[:page],
      per_page: 9
    )
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.organizers << current_user
    @course.location = 'D/D'
    @course.seats = 30

    if @course.save
      redirect_to @course, notice: t('controllers.courses.create.proposed')
    else
      render :new
    end
  end

  def show
    @course = Course.find(params[:id])
  end

  private

  def course_params
    params.require(:course).permit(
      :name, :description, :category_id, lessons_attributes: [
        :id, :time_frame_id, :_destroy
      ]
    )
  end
end
