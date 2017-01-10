module API
  module V1
    class UserExamsController < ApplicationController
      before_filter :authenticate_user!
      skip_before_action :verify_authenticity_token
      load_and_authorize_resource

      clear_respond_to
      respond_to :json

      def create
        #check if user tried two times to pass this exam
        @user_exams = UserExam.get_by_user_id_exam_id current_user.id, params[:exam_id]
        if @user_exams.count == 2
          render :status => 400, :json => {
            :errors => "You used your chances to this exam"
          }.to_json
        end

        @exam = Exam.find params[:exam_id]
        @user_exam = UserExam.new

        @user_exam.exam_id = params[:exam_id]
        @user_exam.user_id = current_user
        @user_exam.passed = false
        authorize! :create, @user_exam

        if @user_exam.save
          render "new"
        else
          render :status => 404, :json => {
            :errors => "User exams not found"
          }.to_json
        end


      end

      def index

        #@user_exams = UserExam.get_by_user_id_exam_id current_user.id, params[:exam_id]
        #authorize! :read, @user_exams
        if @user_exams.count === 0
          render :status => 404, :json => {
            :errors => "User exams not found"
          }.to_json
          return
        end
        render "index"
      end

      def update
        #@user_exam = UserExam.new(user_exam_params)
        #@user_exam = UserExam.find params[:id]

        #get exam
        exam = Exam.find(params[:exam_id])

        #authorize! :update, @user_exam

        #set users scores
        score = 0
        params[:user_exam][:user_answers_attributes].each do |user_answer|
          answer = Answer.find(user_answer["answer_id"])
          if answer.correct == true
            score+=1
          end
        end
        #check if exam is passed
        if score.to_f/exam.questions.count.to_f > 0.5
          passed = true
        else
          passed = false
        end

        @user_exam.score = score
        @user_exam.passed = passed
        @user_exam.user = current_user


        if @user_exam.save
          render @user_exam, notice: 'Exam finished'
        else
          render json status('false')
        end

      end

      def show
        if @user_exam.blank?
          render :status => 404, :json => {
            :errors => "User exams not found"
          }.to_json
        else
          render @user_exam
        end
      end

      private

      def user_exam_params
        params.require(:user_exam).permit(user_answers_attributes: [:question_id, :answer_id])
      end
    end
  end
end
