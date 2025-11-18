class BooksController < ApplicationController
  # Set the book before actions that need it
  before_action :set_book, only: %i[show edit update destroy add_to_wishlist remove_from_wishlist]

  # Ensure the user is authenticated for most actions
  before_action :authenticate_user!, except: %i[index show]

  # Only allow the owner to modify their book
  before_action :authorize_user!, only: %i[edit update destroy]

  # Redirect user to the home page after sign out
  def after_sign_out_path_for(resource_or_scope)
      root_path
  end

  # POST /books/:id/add_to_wishlist
  def add_to_wishlist
      current_user.wishlist_books << @book unless current_user.wishlist_books.include?(@book)
      redirect_back(fallback_location: root_path)
  end

  # DELETE /books/:id/remove_from_wishlist
  def remove_from_wishlist
      current_user.wishlist_books.delete(@book)
      redirect_back(fallback_location: root_path)
  end

  def toggle_favorite
    @book = Book.find(params[:id])
    @book.update(favorite: !@book.favorite)

    redirect_back fallback_location: books_path
  end

  # Display a list of all books
  def index
      if user_signed_in?
        @books = current_user.books
        @finished_books = @books.where(read: true)
        @current_read = @books.where(currently_reading: true)
        @not_started = @books.where(read: false, currently_reading: false)
        @wishlist_books = current_user.wishlist_books
        @top_genre = current_user.top_genre
        @genres = @books.pluck(:genre).compact.uniq.sort
        @favorite_books = @books.where(favorite: true)

        if params[:genre].present?
            selected = params[:genre]
            @books = @books.where(genre: selected)
            @finished_books = @finished_books.where(genre: selected)
            @current_read = @current_read.where(genre: selected)
            @not_started = @not_started.where(genre: selected)
            @favorite_books = @books.where(favorite: true)

        end
      end
  end

  # Show the details of a single book
  def show
    # @book is already set by set_book
  end

  # Initialize a new book
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

  # Render the edit form
  def edit
    # @book is already set by set_book
  end

  # Update an existing book
  def update
      if @book.update(book_params)
        redirect_to books_path, notice: "Book was successfully updated."
      else
        render :edit
      end
  end

  # Delete a book
  def destroy
      @book.destroy
      redirect_to books_path, notice: "Book was successfully deleted."
  end

  # Calculate reading progress percentage
  def progress_percentage
      return 0 unless @book.total_pages && @book.page_number
      (@book.page_number.to_f / @book.total_pages.to_f) * 100
  end

  private

  # Find the book by ID
  def set_book
      @book = Book.find(params[:id])
  end

  # Strong parameters for books
  def book_params
      params.require(:book).permit(:title, :author, :currently_reading, :genre, :page_number, :read, :rating, :total_pages, :wishlist)
  end

  # Ensure only the owner can edit/update/destroy
  def authorize_user!
      redirect_to books_path, alert: "You are not authorized to do that." unless @book.user == current_user
  end
end
