ALasOcho::Application.routes.draw do
  root to: "pages#home"

  resources :events, :only => [:new, :create, :show, :update] do
    resources :comments, :only => [:create]
    get :invite_people

    resource :attendance, :only => [:create, :destroy]
  end

  match "/auth/:provider/callback" => "sessions#create"
end
