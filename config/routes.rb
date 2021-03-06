Rails.application.routes.draw do

  devise_for :users, :controllers => {
    sessions: 'api/v1/sessions',
    registrations: 'api/v1/registrations'
  }, defaults: { format: :json }


  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      devise_scope :user do
        delete '/users/sign_out' => 'sessions#destroy', :as => 'logout'
        post '/users/sign_in' => 'sessions#create', :as => 'user_sign'
        post '/users/sign_up' => 'registrations#create', :as => 'user_sign_up'
      end
      resources :courses, :only => [:create, :update, :index, :show] do
        resources :lessons, :only => [:create, :update, :index, :show]
        resources :exams, :only => [:create, :update, :index, :show] do
          resources :questions, :only => [:create, :update, :index]
          resources :user_exams, :only => [:create, :index, :update, :show]
        end
      end
    end
  end


end
