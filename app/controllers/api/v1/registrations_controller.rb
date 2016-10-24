module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
    skip_before_filter :verify_authenticity_token

      clear_respond_to
      respond_to :json

      def create

        user = User.new(user_params)

        if user.save
          render :status => 201, :json => {
            :user =>  user,
            :token => JWTWrapper.encode({ user_id: user.id, first_name: user.first_name })
          }.to_json
          return
        else
          warden.custom_failure!
          render :json => user.errors, :status=>422
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
      end
    end
  end
end
