# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user! # Ensure the user is authenticated before accessing the profile

  # Show the user's profile page with their books
  def show
    @user = current_user  # Fetch the current logged-in user
    @books = @user.books   # Get all books associated with the current user
    @current_read = @user.books.where(read: false)  # Books that are not finished
    @finished_books = @user.books.where(read: true) # Books that are finished
  end
end
