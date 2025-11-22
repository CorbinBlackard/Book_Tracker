class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy add_to_wishlist remove_from_wishlist toggle_favorite]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]

  # Stats needed for sidebar + genre buttons
  before_action :set_book_stats, only: %i[index show new edit]

  # Redirect user to home after sign-out
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # --------------------------
  # Wishlist Features
  # --------------------------

  def add_to_wishlist
    current_user.wishlist_books << @book unless current_user.wishlist_books.include?(@book)
    redirect_back(fallback_location: root_path)
  end

  def remove_from_wishlist
    current_user.wishlist_books.delete(@book)
    redirect_back(fallback_location: root_path)
  end

  # Toggle favorites
  def toggle_favorite
    @book.update(favorite: !@book.favorite)
    redirect_back fallback_location: books_path
  end

  # --------------------------
  # INDEX — Main Books Page
  # --------------------------

  def index
    if user_signed_in?
      @books = current_user.books.order(created_at: :desc)

      # Pre-filter sets
      @finished_books   = @books.where(read: true)
      @current_read     = @books.where(currently_reading: true)
      @not_started      = @books.where(read: false, currently_reading: false)
      @wishlist_books   = current_user.wishlist_books
      @favorite_books   = @books.where(favorite: true)
      @top_genre        = current_user.top_genre
      @sort_by_rating   = [ 1, 2, 3, 4, 5 ]

      # --------------------
      # GENRE FILTER
      # --------------------
      if params[:genre].present?
        selected = params[:genre]
        @books          = @books.where(genre: selected)
        @finished_books = @finished_books.where(genre: selected)
        @current_read   = @current_read.where(genre: selected)
        @not_started    = @not_started.where(genre: selected)
        @favorite_books = @favorite_books.where(genre: selected)
      end

      # --------------------
      # RATING FILTER
      # --------------------
      if params[:rating].present?
        selected = params[:rating]
        @books          = @books.where(rating: selected)
        @finished_books = @finished_books.where(rating: selected)
        @current_read   = @current_read.where(rating: selected)
        @not_started    = @not_started.where(rating: selected)
        @favorite_books = @favorite_books.where(rating: selected)
      end

    else
      @books = Book.none
    end
  end

   # --------------------------
   # SHOW
   # --------------------------

   def show
      @genres = current_user.books.pluck(:genre).compact.uniq.sort
   end

  # --------------------------
  # NEW / CREATE
  # --------------------------

  def new
    @book = Book.new
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      redirect_to root_path, notice: "Book added!"
    else
      render :new
    end
  end

  # --------------------------
  # EDIT / UPDATE / DESTROY
  # --------------------------

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted."
  end

  # --------------------------
  # Helpers
  # --------------------------

  def progress_percentage
    return 0 unless @book.total_pages && @book.page_number
    (@book.page_number.to_f / @book.total_pages.to_f) * 100
  end

  private

  # Load the book
  def set_book
    @book = Book.find(params[:id])
  end

  # Only owner can modify
  def authorize_user!
    redirect_to books_path, alert: "You are not authorized to do that." unless @book.user == current_user
  end

  # Sidebar stats + genres here so they always exist
  def set_book_stats
    if user_signed_in?
      user_books = current_user.books

      @total_books      = user_books.count
      @books_read       = user_books.where(read: true)
      @unread           = user_books.where(read: false)
      @total_pages_read = @books_read.sum(:total_pages)
      @average_rating   = @books_read.average(:rating)&.round(1) || 0
      @five_star_books  = user_books.where(rating: 5)

      # FIX: genres available everywhere
      @genres = user_books.pluck(:genre).compact.uniq.sort
    else
      @total_books      = 0
      @books_read       = []
      @unread           = []
      @total_pages_read = 0
      @average_rating   = 0
      @five_star_books  = []
      @genres           = []   # Prevent nil errors
    end
  end

  # Strong params
  def book_params
    params.require(:book).permit(
      :title, :author, :currently_reading, :genre,
      :page_number, :read, :rating, :total_pages, :wishlist
    )
  end
end
