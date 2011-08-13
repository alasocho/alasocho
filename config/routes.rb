ALasOcho::Application.routes.draw do
  resources :events, :only => [:new, :create]
end
