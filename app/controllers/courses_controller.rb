class CoursesController < ApplicationController
  decorates_assigned :course

  def index
    @courses = Course.all.paginate(page: params[:page], per_page: 9)
  end

  def show
    @course = Course.find(params[:id])
  end
end
