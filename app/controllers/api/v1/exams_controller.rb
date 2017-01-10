module API
  module V1
    class ExamsController < ApplicationController
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token
      load_and_authorize_resource
      #before_action :set_exam, only: [:show, :update]
      clear_respond_to
      respond_to :json

      def index
=begin
        if current_user.role === 'admin'
          @exams = Exam.all
        elsif
          @exams = Exam.get_active
        end
        authorize! :read, @exams
=end
        if @exams.count === 0
          render :status => 404, :json => {
            :errors => "Exams not found"
          }.to_json
        else
          render "index"
        end
      end

      def create
        #@exam = Exam.new(exam_params)
        #authorize! :create, @exam
        if @exam.save
          render @exam, notice: 'Lesson added'
        else
          render json status('false')
        end
      end

      def update
        #authorize! :update, @find_exam
        @exam.update(exam_params)
        render @exam
      end

      private

      def set_exam
        @find_exam = Exam.find(params[:id])
      end

      def exam_params
        params.require(:exam).permit(:title, :course_id)
      end

    end
  end
end
