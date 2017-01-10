require 'rails_helper'

RSpec.describe API::V1::UserExamsController, type: :controller do
    render_views

    let(:current_user) { FactoryGirl.create(:user) }
    let(:token) { JWTWrapper.encode({ user_id: current_user.id }) }

    let!(:course) { FactoryGirl.create(:course)}
    let!(:exam) { FactoryGirl.create(:exam, course: course) }

    #check responds when user is not logged in

    context 'without login' do

      it 'prohibit access without user token' do
        get :index, :course_id => course.id, :exam_id => exam.id, :format => 'json'

        expect(response.status).to eq(401)
      end
    end

    #check responds when user is logged in, but wihtout creating users exams
    context 'with login and errors' do

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'responds with status 404 - user exams not found' do
        get :index, :course_id => course.id, :exam_id => exam.id, :format => 'json'

        expect(response.status).to eq(404)
      end
    end

    #save user exam
    context 'Operatins on users exams' do
      let!(:questions) { FactoryGirl.create_list(:question, 5, exam: exam) }
      let!(:user_exam) { FactoryGirl.create(:user_exam, exam: exam, user: current_user) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'saves user exam with valid answers' do

        user_answers = []

        questions.each do |question|

          question.answers.each do |answer|
            if answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
            end
          end
        end

        put :update, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id,
           user_exam: {
              "user_answers_attributes": user_answers
            }, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body["score"]).to eq(5)
        expect(body["passed"]).to eq(true)
      end

      it 'With more than 50% valid answers' do
        user_answers = []
        correct_count = 0
        questions.each do |question|

          question.answers.each do |answer|

            if correct_count <= question.answers.count/2+1

              if answer.correct == true
                correct_count+=1
                user_answers << {"question_id" => question.id, "answer_id" => answer.id }
                #this question is answered, so break the loop
                break
              end

            elsif answer.correct == false
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
              #this question is answered, so break the loop
              break
            end
          end

        end

        put :update, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id,
           user_exam: {
              "user_answers_attributes": user_answers
            }, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body["score"]).to eq(correct_count)
        expect(body["passed"]).to eq(true)

      end


      it 'Invalid answers' do
        user_answers = []
        incorrect_count = 0
        questions.each do |question|

          question.answers.each do |answer|

            if incorrect_count <= question.answers.count/2+1

              if answer.correct == false
                incorrect_count+=1
                user_answers << {"question_id" => question.id, "answer_id" => answer.id }
                #this question is answered, so break the loop
                break
              end

            elsif answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
              #this question is answered, so break the loop
              break
            end
          end

        end

        put :update, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id,
           user_exam: {
              "user_answers_attributes": user_answers
            }, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        #user_answers.count - count of all answers - incorrect count
        expect(body["score"]).to eq(user_answers.count - incorrect_count)
        expect(body["passed"]).to eq(false)

      end


    end

    context 'Without creating user exam' do

      let!(:questions) { FactoryGirl.create_list(:question, 5, exam: exam) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'Create new user exam on start' do
        post :create, :course_id => course.id, :exam_id => exam.id, :format => 'json',
              user_exam: {"user_answers_attributes" => {}}

        body = JSON.parse(response.body)
        expect(body["user_exam"]["id"]).to eq(1)
        expect(body["exam"]["questions"].count).to eq(questions.count)
      end
    end


    context 'Regullar user' do
      let!(:questions) { FactoryGirl.create_list(:question, 5, exam: exam) }

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      let!(:user_exam) { FactoryGirl.create(:user_exam, exam: exam, user: user_regullar) }
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      it 'Create new user exam header' do
        post :create, :course_id => course.id, :exam_id => exam.id, :format => 'json',
            user_exam: {"user_answers_attributes" => {}}

        body = JSON.parse(response.body)
        expect(body["user_exam"]["id"]).to eq(2)
        expect(body["exam"]["questions"].count).to eq(questions.count)
      end

      it 'Add user answers' do
        user_answers = []

        questions.each do |question|

          question.answers.each do |answer|
            if answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
            end
          end
        end

        put :update, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id,
           user_exam: {
              "user_answers_attributes": user_answers
            }, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body["score"]).to eq(5)
        expect(body["passed"]).to eq(true)
      end

    end

    context 'Check user permissions' do

      let!(:questions) { FactoryGirl.create_list(:question, 5, exam: exam) }

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      let!(:user_exam) { FactoryGirl.create(:user_exam, exam: exam, user: current_user) }
      let!(:exam_list) { FactoryGirl.create_list(:user_exam, 2, exam: exam, user: user_regullar)}

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      it 'Prohibit update user exam to other person' do

        user_answers = []

        questions.each do |question|

          question.answers.each do |answer|
            if answer.correct == true
              user_answers << {"question_id" => question.id, "answer_id" => answer.id }
            end
          end
        end

        put :update, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id,
           user_exam: {
              "user_answers_attributes": user_answers
            }, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(403)
        expect(body["error"]).to eq("You are not authorized to access this page.")

      end


      it 'Show exam list of this user' do

        get :index, :course_id => course.id, :exam_id => exam.id, :format => 'json'
        body = JSON.parse(response.body)

        expect(body.count).to eq(2)
        body.each do |exam_response|
          expect(exam_response['user_id']).to eq(user_regullar.id)
        end

      end

      it 'Show concrete exam of this user' do
        get :show, :course_id => course.id, :exam_id => exam.id, :id => exam_list.first.id, :format => 'json'
        body = JSON.parse(response.body)
        expect(body['id']).to eq(exam_list.first.id)
        expect(body['passed']).to eq(false)

      end

      it 'Prohibit showing exam of another user' do
        get :show, :course_id => course.id, :exam_id => exam.id, :id => user_exam.id, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(403)
      end


    end

end
