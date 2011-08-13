ALasOcho::Application.routes.draw do
  root to: "pages#home"

  resources :events, :only => [:edit, :new, :create, :show, :update, :destroy, :index] do
    resources :comments, :only => [:create]
    post :invite
    get :invite_people

    resource :attendance, :only => [:create, :destroy]
  end

  resource :account, :only => [:edit, :update] do
    resource :merge, :only => [:new, :create]
  end
  get "/my_events" => "events#my_events"

  match "/auth/sign_out" => "sessions#destroy"
  match "/auth/:provider/callback" => "sessions#create"
end
