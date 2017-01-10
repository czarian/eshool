require 'rails_helper'

RSpec.describe API::V1::ExamsController, type: :controller do
    render_views
    let(:current_user) { FactoryGirl.create(:user) }
    let(:token) { JWTWrapper.encode({ user_id: current_user.id }) }
    let!(:course) { FactoryGirl.create(:course)}

    context 'without login' do

      it 'prohibit access without user token' do
        get :index, :course_id => course.id, :format => 'json'

        expect(response.status).to eq(401)
      end
    end

    context 'with login and without creating' do
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'try to get list of exams when there are no exams' do

        get :index, :course_id => course.id, :format => 'json'

        body = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(body['errors']).to eq "Exams not found"
      end
    end

    context 'with login and creating as admin' do

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      let!(:exams) { FactoryGirl.create_list(:exam, 5, course: course) }
      let!(:exams_inProgress) { FactoryGirl.create_list(:exam, 5, course: course, status: 1) }

      it 'get list of lesson' do
        get :index, :course_id => course.id, :format => 'json'

        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        5.times do |i|
          expect(body[i]['exam_header']['title']).to eq "Exam #{i+1} course #{course.id} name"
          expect(body[i+5]['exam_header']['status']).to eq "inProgress"
        end

      end

      it 'update an exam' do
        put :update, :course_id => course.id,
         exam: { "title": "new exam title" }, :format => 'json', :id=>2, :content_type => 'application/json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body['exam_header']['title']).to eq("new exam title")
      end



    end

    context 'regullar user with creating exams' do

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar", email: "123@ccc.com") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      let!(:exams) { FactoryGirl.create_list(:exam, 5, course: course) }
      let!(:exams_inProgress) { FactoryGirl.create_list(:exam, 5, course: course, status: 1) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      it 'show only active exams to regullar user' do
        get :index, :course_id => course.id, :format => 'json'
        body = JSON.parse(response.body)

        body.each do |exam|
          expect(exam['exam_header']['status']).to eq("active")
        end
      end
    end

    context 'admin without creating' do
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end
      let!(:exam) { FactoryGirl.build(:exam) }

      it 'allow create exam' do
        post :create, :course_id => course.id,
           exam: {
              "title": exam.title,
            }, :format => 'json'

          body = JSON.parse(response.body)

          expect(response.status).to eq(200)
          expect(body['exam_header']['title']).to eq(exam.title)
          expect(body['exam_header']['status']).to eq('inProgress')
      end
    end

    context 'check users permissions' do

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      let!(:exam) {FactoryGirl.build(:exam)}

      it 'prohibit creating new course' do
        post :create, :course_id => course.id,
         exam: {
            "title": exam.title,
          }, :format => 'json'
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)

        expect(body['error']).to eq("You are not authorized to access this page.")
      end
    end
end
