module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_filter :verify_signed_out_user
      skip_before_action :verify_authenticity_token

      clear_respond_to
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options.merge({store:false}))
        render :status => 200, :json => {
          :error => "Success", :user =>  current_user,
          :token => JWTWrapper.encode({ user_id: current_user.id, first_name: current_user.first_name })
        }.to_json


      end

      def destroy
          sign_out(resource_name)
          render :status => 204, :json => {:success => true}
      end

      def failure
        render :json => {:success => false, :errors => ["Login Failed"]}
      end


    end

  end
end
