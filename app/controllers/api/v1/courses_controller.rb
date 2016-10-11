module Api
  module V1
    class CoursesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_course, only: [:show, :update]

      clear_respond_to
      respond_to :json

      def index
        @courses = Course.get_active
      end

      def update
        @find_course.update(course_params)
        render @find_course
      end

      def show
      end

      def create
        @course = Course.new(course_params)
        if @course.save
          render @course, notice: 'Book added'
        else
          render json status('false')
        end
      end

    private

      def set_course
        @find_course = Course.find(params[:id])
      end

      def course_params
        params.require(:course).permit(:name, :description, :status)
      end
    end

  end
end
