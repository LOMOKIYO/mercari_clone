Rails.application.routes.draw do
  resources :mypages, only: [:index, :destroy, :edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: "users/sessions",
  }

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end


end
