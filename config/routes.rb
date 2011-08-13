ALasOcho::Application.routes.draw do
  root to: "pages#home"

  resources :events, :only => [:new, :create, :show]

  match "/auth/:provider/callback" => "sessions#create"
end
