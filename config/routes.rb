ALasOcho::Application.routes.draw do
  root to: "pages#home"

  get "dashboard", :to => "dashboard#index", :as => :user_root

  get "/events/public" => "events#public", :as => "public_events"
  resources :events, :only => [:edit, :new, :create, :show, :update, :destroy, :index] do
    resources :comments, :only => [:create]
    post :invite
    get :invite_people
    get :confirmed, :action => "confirmed", :as => "confirmed"
    get :invited, :action => "invited", :as => "invited"
    get :waitlisted, :action => "waitlisted", :as => "waitlisted"
    get :declined, :action => "declined", :as => "declined"
    get :everyone, :action => "everyone", :as => "everyone"

    resource :attendance, :only => [:create, :destroy]
  end

  resource :account, :only => [:edit, :update] do
    resource :merge, :only => [:new, :create]
  end


  match "/auth/sign_out" => "sessions#destroy"
  match "/auth/:provider/callback" => "sessions#create"
end
