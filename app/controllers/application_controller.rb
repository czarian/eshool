class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  #if some resource is not found return status with json

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render :status => 404, :json => {
          :error => exception.message
        }.to_json
  end

  #
  rescue_from CanCan::AccessDenied do |exception|

    render :status => 403, :json => {
          :error => exception.message
        }.to_json
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

end
