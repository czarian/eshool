Rails.application.routes.draw do
  devise_for :users, :controllers => {sessions: 'api/v1/sessions'}, defaults: { format: :json }
  resources :firsts


  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      #devise_scope :user do
       # delete '/users/sign_out' => 'sessions#destroy', :as => 'logout'
        #post '/users/sign_in' => 'sessions#create', :as => 'user_sign'
      #end
      resources :courses, :only => [:create, :update, :index]
    end
  end


end
