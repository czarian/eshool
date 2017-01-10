require 'rails_helper'

RSpec.describe API::V1::LessonsController, type: :controller do
    render_views
    let(:current_user) { FactoryGirl.create(:user) }
    let!(:course) { FactoryGirl.create(:course)}


    let(:token) { JWTWrapper.encode({ user_id: current_user.id }) }

    let(:auth_headers) { "Authorization: Bearer #{token}" }

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

      it 'try to get list of lessons when there are no lessons' do

        get :index, :course_id => course.id, :format => 'json'

        body = JSON.parse(response.body)

        expect(response.status).to eq(404)
        expect(body['errors']).to eq "Lessons not found"
      end

      it 'try to show lesson' do
        get :show, :course_id => course.id, :id => 1, :format => 'json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(404)
      end

    end

  context 'with login and with creating' do

    let!(:lessons) { FactoryGirl.create_list(:lesson, 10, course: course) }

    before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
    end

    it 'get a list of lessons'do
      get :index, :course_id =>lessons[0].course.id, :format => 'json'
      body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      10.times do |i|
          expect(body[i]['name']).to eq "Lesson #{i+1} course #{course.id} name"
      end
    end

    it 'update a lesson' do
        put :update, :course_id => course.id,
         lesson: { "name": "new lesson name" }, :format => 'json', :id=>2, :content_type => 'application/json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body['name']).to eq("new lesson name")
    end

    it 'show a lesson' do
      get :show, :course_id => course.id, :id => lessons[0].id, :format => 'json'
      body = JSON.parse(response.body);

      expect(response.status).to eq(200)
      expect(body["name"]).to eq(lessons[0].name)
    end

  end

  context 'with login, without creating lessons' do
    before(:each) do
      controller.request.headers['Authorization'] = "Bearer #{token}"
    end

    let!(:lesson) {FactoryGirl.build(:lesson)}

    it 'save new lesson' do
        post :create, :course_id => course.id,
         lesson: {
            "name": lesson.name,
            "description": lesson.description,
          }, :format => 'json'
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['name']).to eq(lesson.name)
      end

  end

  context 'check users permissions' do

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      let!(:lesson) {FactoryGirl.build(:lesson)}

      it 'prohibit creating new course' do
        post :create, :course_id => course.id,
         lesson: {
            "name": lesson.name,
            "description": lesson.description,
          }, :format => 'json'
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)

        expect(body['error']).to eq("You are not authorized to access this page.")
      end

    end

    context 'check regullar user with creating a lesson' do

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      let!(:lessons) { FactoryGirl.create_list(:lesson, 10, course: course) }

      it 'show a lesson' do
        get :show, :course_id => course.id, :id => lessons[0].id, :format => 'json'
        body = JSON.parse(response.body);

        expect(response.status).to eq(200)
        expect(body["name"]).to eq(lessons[0].name)
      end

    end

end
