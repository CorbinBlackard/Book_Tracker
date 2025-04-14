Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Health check route for uptime monitoring (optional)
  get "up" => "rails/health#show", as: :rails_health_check

  # Books routes (standard RESTful routes for books)
  resources :books do
    resources :notes, only: [ :create, :edit, :update, :destroy ] # Nested routes for notes under books
  end

  # User routes: Only the 'show' route is available for users
  resources :users, only: [ :show ]

  # Set the root path of the application (homepage)
  root "books#index"
end
