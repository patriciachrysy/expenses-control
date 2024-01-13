Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/register" => "devise/registrations#new"
    get "/profile" => "devise/registrations#edit"
    get "/logout" => "devise/sessions#destroy"
  end

  resources :categories

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
