ALasOcho::Application.routes.draw do
  root to: "pages#home"

  resource :dashboard, :only => [:show]
  get "terms_and_conditions", :to => "pages#terms_and_conditions", :as => :terms_and_conditions

  get "/events/public" => "events#public", :as => "public_events"
  resources :events do
    post :invite
    put :publish
    get :invite_people

    scope controller: :guests do
      get "guests/confirmed",  to: :confirmed,  as: :confirmed_guests
      get "guests/waitlisted", to: :waitlisted, as: :waitlisted_guests
      get "guests/invited",    to: :invited,    as: :invited_guests
      get "guests/declined",   to: :declined,   as: :declined_guests
      get "guests/manage",     to: :manage,     as: :manage_guests
    end

    resource :attendance, :only => [:create, :destroy]

    resources :comments, :only => [:create]
    resources :invitations, :only => [:new, :create]
  end

  resource :account, :only => [:edit, :update] do
    resource :merge, :only => [:new, :create]
  end


  match "/auth/sign_out" => "sessions#destroy"
  match "/auth/:provider/callback" => "sessions#create"
end
