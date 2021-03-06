module API
  module V1
    class QuestionsController < ApplicationController
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token
      #before_action :set_question, only: [:show, :update]
      load_and_authorize_resource

      clear_respond_to
      respond_to :json

      def index
        #@questions = Question.get_by_exam_id params[:exam_id]

        #authorize! :read, @questions
        if @questions.count === 0
          render :status => 404, :json => {
            :errors => "Questions not found"
          }.to_json
        else
          render "index"
        end
      end

      def create
        #@question = Question.new(question_params)
        #authorize! :create, @question
        if @question.save
          render @question, notice: 'Qusetion added'
        else
          render :status => 400, :json => {
            :errors => @question.errors.as_json
          }.to_json
        end
      end

      def update
        @question.update(question_params)
        render @question
      end

      private

      def set_question
        @question = Question.find(params[:id])
      end

      def question_params
        params.require(:question).permit(:content, answers_attributes: [:id, :content, :correct, :_destroy])
      end

    end
  end
end
