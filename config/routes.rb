Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Health check route for uptime monitoring (optional)
  get "up" => "rails/health#show", as: :rails_health_check

  # Set the root path of the application (homepage)
  root "books#index"

  # User routes: Only the 'show' route is available for users
  resources :users, only: [ :show ]

  # Books routes (standard RESTful routes for books)
  resources :books do
    # Nested notes routes for books
    resources :notes, only: [ :create, :edit, :update, :destroy ]

    # Wishlist member routes for books
    member do
      post :add_to_wishlist
      delete :remove_from_wishlist
      patch :toggle_favorite
    end
  end
end
