 require "rails_helper"
 RSpec.describe Api::V1::SessionsController, type: :controller do

  let(:current_user) { FactoryGirl.create(:user) }



  it 'responds with a valid JWT after login' do

    @request.env["devise.mapping"] = Devise.mappings[:user]
    post :create, { user: { email: current_user.email, password: current_user.password} }, :content_type => 'application/json', :format => :json

    token = JSON.parse(response.body)['token']
    claims = JWTWrapper.decode token
    expect(claims['user_id']).to eq(1)
  end

  it 'logout user' do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    delete :destroy
    expect(response.status).to eq(204)
  end

end
