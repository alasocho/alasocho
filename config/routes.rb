ALasOcho::Application.routes.draw do
  resources :events, :only => [:new, :create, :show]

  match "/auth/:provider/callback" => "sessions#create"
end
