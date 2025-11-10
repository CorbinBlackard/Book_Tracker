class BooksController < ApplicationController
  # Before running certain actions, find the book based on the ID in the URL
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ] # Ensure only the user who created the book can modify it

  # Redirect user to the home page after sign out
  def after_sign_out_path_for(resource_or_scope)
    root_path # Or whichever path you want to redirect to after logout
  end

  # Display a list of all books, along with the finished and currently reading books
  def index
    if user_signed_in?
      @books = current_user.books # All books associated with the current user
      @finished_books = current_user.books.where(read: true)  # Books marked as 'read'
      @current_read = current_user.books.where(read: false)   # Books that are still being read
    end
  end

  # Show the details of a single book
  def show
    # No need to define any logic here, as @book is already set by set_book before this action
  end

  # Initialize a new empty book object for the form
  def new
    @book = Book.new
  end

  # Create a new book record
  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to root_path, notice: "Book added!"
    else
      render :new
    end
  end

  # Render the edit form for the book
  def edit
    # The @book instance is already set by the 'before_action' callback
  end

  # Update the existing book with the new form data
  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  # Delete a book from the database and redirect to the books list
  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  end

  # Calculate the progress percentage for the current book based on pages read and total pages
  def progress_percentage
    return 0 unless @book.total_pages && @book.page_number
    (@book.page_number.to_f / @book.total_pages.to_f) * 100
  end

  private

  # Set the book instance variable before certain actions (show, edit, update, destroy)
  def set_book
    @book = Book.find(params[:id])
  end

  # Strong parameters to whitelist the fields allowed for creating or updating a book
  def book_params
    params.require(:book).permit(:title, :author, :currently_reading, :genre, :page_number, :read, :rating, :total_pages)
  end

  # Ensure only the user who created the book can modify it
  def authorize_user!
    redirect_to books_path, alert: "You are not authorized to do that." unless @book.user == current_user
  end
end
