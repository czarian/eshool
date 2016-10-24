require "rails_helper"
RSpec.describe Api::V1::RegistrationsController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:user) { FactoryGirl.build(:user) }
  it 'creating new user fails with password confirmation' do

    post :create, { user: {
        email: user.email,
        password: user.password,
        password_confirmation: 'fdsa',
        first_name: user.first_name,
        last_name: user.last_name
      }
    },
    :content_type => 'application/json',
    :format => :json
    expect(response.status).to eq(422)
  end

  it 'create new user and response with jwt' do
    post :create, { user: {
        email: user.email,
        password: user.password,
        password_confirmation: user.password,
        first_name: user.first_name,
        last_name: user.last_name
      }
    },
    :content_type => 'application/json',
    :format => :json
    token = JSON.parse(response.body)['token']
    claims = JWTWrapper.decode token
    expect(claims['first_name']).to eq(user.first_name)
    expect(response.status).to eq(201)
  end

  context 'with creating user before' do

      let(:current_user) { FactoryGirl.create(:user) }

    it 'create new user and try to create second with the same email' do
      post :create, { user: {
        email: current_user.email,
        password: current_user.password,
        password_confirmation: current_user.password,
        first_name: current_user.first_name,
        last_name: current_user.last_name
        }
      },
      :content_type => 'application/json',
      :format => :json
      expect(response.status).to eq(422)
    end

  end
end
