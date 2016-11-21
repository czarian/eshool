 require "rails_helper"
 RSpec.describe Api::V1::CoursesController, type: :controller do
    render_views
    let(:current_user) { FactoryGirl.create(:user) }



    let(:token) { JWTWrapper.encode({ user_id: current_user.id }) }

    let(:auth_headers) { "Authorization: Bearer #{token}" }

    context 'without login' do

      it 'prohibit access without user token' do
        get :index, Headers: {:content_type => 'application/json', :format => :json}

        expect(response.status).to eq(401)

      end
    end

    context 'with login' do

      let!(:courses) { FactoryGirl.create_list(:course, 10) }


      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'access with valid token' do
        #sign_in current_user

        get :index, format: :json#,  nil, {"Authorization" => "Bearer #{token}" }
        expect(response.status).to eq(200)
      end

      it 'get list of courses' do
        get :index, format: :json

        body = JSON.parse(response.body)
        #puts body

        expect(response.status).to eq(200)

        10.times do |i|
          expect(body[i]['name']).to eq "course name#{i+11}"
        end


      end

      it 'change status of course' do
        put :update, course: { "name": "new course name1" }, :format => 'json', :id=>1, :content_type => 'application/json'
        body = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(body['name']).to eq("new course name1")
      end



    end

    context 'save courses with login' do

      let!(:course) { FactoryGirl.build(:course)}
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{token}"
      end

      it 'save new course' do
        post :create, course: {
            "name": course.name,
            "description": course.description,
            "status": course.status
          }, :format => 'json'
        expect(response.status).to eq(200)
        body = JSON.parse(response.body)
        expect(body['name']).to eq(course.name)
      end
    end

    context 'check users permissions' do

      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }

      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      let!(:course) { FactoryGirl.build(:course)}

      it 'prohibit creating new course' do
        post :create, course: {
            "name": course.name,
            "description": course.description,
            "status": course.status
          }, :format => 'json'
        expect(response.status).to eq(403)
        body = JSON.parse(response.body)

        expect(body['error']).to eq("You are not authorized to access this page.")
      end
    end

    context 'with user permissions and without creating courses' do
      let(:user_regullar) { FactoryGirl.create(:user, role: "regullar") }
      let(:regullar_token) { JWTWrapper.encode({ user_id: user_regullar.id }) }
      before(:each) do
        controller.request.headers['Authorization'] = "Bearer #{regullar_token}"
      end

      it 'check index response status with no courses' do
        get :index, format: :json#,  nil, {"Authorization" => "Bearer #{token}" }
        expect(response.status).to eq(404)
      end


    end

 end
