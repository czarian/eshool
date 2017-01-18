require 'rails_helper'

RSpec.describe API::V1::QuestionsController, type: :controller do
    render_views

    let(:current_user) { FactoryGirl.create(:user) }
    let(:token) { JWTWrapper.encode({ user_id: current_user.id }) }

    let!(:course) { FactoryGirl.create(:course)}
    let!(:exam) { FactoryGirl.create(:exam, course: course) }

    context 'without login' do

      it 'prohibit access without user token' do
        get :index, :exam_id => exam.id, :course_id => course.id, :format => 'json'

        expect(response.status).to eq(401)
      end
    end

    context 'with login and without creating' do
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'try to get list of questions when there are no exams' do

        get :index, :exam_id => exam.id, :course_id => course.id, :format => 'json'

        body = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(body['errors']).to eq "Questions not found"
      end
    end

    context 'with login and with creating' do
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      let!(:question) { FactoryGirl.create_list(:question, 5, exam: exam) }

      it 'get list of exams' do
        get :index, :exam_id => exam.id, :course_id => course.id, :format => 'json'
        body = JSON.parse(response.body)

        body.each do |question|
          expect(question['answers'].count).to eq(3)
        end
        expect(response.status).to eq(200)
      end

    end

    context 'administrations' do
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      let!(:question) { FactoryGirl.build(:question, exam: exam) }

      it 'create questions with answers' do

        answers = []
        question.answers.each do |answer|
          answers << {"content" => answer.content, "correct" => answer.correct}
        end


        post :create, course_id: course.id, :exam_id => exam.id,
           question: {
              "content": question.content,
              "answers_attributes": answers
            }, :format => 'json'

            body = JSON.parse(response.body)

            expect(response.status).to eq(200)
            expect(body['content']).to eq(question.content)
            expect(body['answers'].count).to eq(answers.count)
      end

      it 'prohibit creating question without answers' do
        post :create, course_id: course.id, :exam_id => exam.id,
           question: {
              "content": question.content,
            }, :format => 'json'

        body = JSON.parse(response.body)
        expect(body["errors"]["answers"][0]).to eq("can't be blank")
      end

      it 'update answers' do
        question.save
        answers = []
        question.answers.each do |answer|
          answers << {"id" => answer.id, "content" => "New content", "correct" => answer.correct}
        end
        put :update, course_id: course.id, :exam_id => exam.id,
         question: { "answers_attributes": answers },
          :format => 'json', :id=>question.id, :content_type => 'application/json'

          body = JSON.parse(response.body)
          expect(response.status).to eq(200)
          body['answers'].each do |answer|
            expect(answer['content']).to eq("New content")
          end

      end

      it 'delete answers' do
        question.save
        answers = []
        question.answers.each do |answer|
          if answer.id == 1
            answers << {"id" => answer.id, "content" => "New content", "_destroy" => true,  "correct" => answer.correct}
          end
        end
        put :update, course_id: course.id, :exam_id => exam.id,
         question: { "answers_attributes": answers },
          :format => 'json', :id=>question.id, :content_type => 'application/json'

        body = JSON.parse(response.body)
        expect(body['answers'].count).to eq(2)
      end
    end
end
