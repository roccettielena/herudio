class CoursesController < ApplicationController
  has_scope :by_name
  has_scope :by_category

  decorates_assigned :course

  def index
    @courses = apply_scopes(Course.all).paginate(page: params[:page], per_page: 9)
  end

  def show
    @course = Course.find(params[:id])
  end
end
