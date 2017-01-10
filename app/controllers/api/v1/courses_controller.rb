module API
  module V1
    class CoursesController < ApplicationController
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token
      load_and_authorize_resource
      #before_action :set_course, only: [:show, :update]

      clear_respond_to
      respond_to :json

      def index
        #authorize! :read, @course
        @courses = Course.get_active
        if @courses.count === 0
          render :status => 404, :json => {
            :errors => "Courses not found"
          }.to_json
        end
      end

      def update
        #@course loaded by load_and_authorize_resource
        @course.update(course_params)
        #authorize! :update, @find_course
        render @course
      end

      def show
        if @course.blank?
          render :status => 404, :json => {
            :errors => "Course not found"
          }.to_json
        else
          render @course
        end
      end

      def create
        #@course = Course.new(course_params)
        #authorize! :create, @course
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
        params.require(:course).permit(:id, :name, :description, :status)
      end
    end

  end
end
