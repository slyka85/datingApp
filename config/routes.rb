Rails.application.routes.draw do
  
  root 'home#index'
  
  resources :users do
    member do
      get 'profile'
      get 'matches'
    end
  end
  
  # get   '/auth/facebook/callback', to: "sessions#create"
  match '/auth/facebook/callback' => 'sessions#create', via: [:get, :post] 
  match '/sign_out', to: "sessions#destroy", via: :delete

  post   'create_friendship' => "friendships#create"
  delete 'delete_friendship' => "friendships#destroy"

  get 'matches/get_email' => "users#get_email"
  


end