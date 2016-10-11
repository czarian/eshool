class FirstsController < ApplicationController
  before_filter :authenticate_user!

  clear_respond_to
  respond_to :json



  def index
  end
end
