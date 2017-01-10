module API
  module V1
    class LessonsController < ApplicationController
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token
      load_and_authorize_resource
      #before_action :set_lesson, only: [:show, :update]

      clear_respond_to
      respond_to :json

      def index
        #@lessons = Lesson.get_by_course_id params[:course_id]

        #authorize! :read, @lessons
        if @lessons.count === 0
          render :status => 404, :json => {
            :errors => "Lessons not found"
          }.to_json
        end
      end

      def show
        if @lesson.blank?
          render :status => 404, :json => {
            :errors => "Course not found"
          }.to_json
        else
          render @lesson
        end
      end

      def create
        #@lesson = Lesson.new(lesson_params)
        #authorize! :create, @lesson
        if @lesson.save
          render @lesson, notice: 'Lesson added'
        else
          render json status('false')
        end
      end

      def update
        @lesson.update(lesson_params)
        #authorize! :update, @find_lesson
        render @lesson
      end

      private

      def set_lesson
        @find_lesson = Lesson.find(params[:id])
      end

      def lesson_params
        params.require(:lesson).permit(:id, :name, :description, :course_id)
      end

    end
  end
end
