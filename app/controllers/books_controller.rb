class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_book, only: %i[show edit update destroy add_to_wishlist remove_from_wishlist toggle_favorite]
  before_action :authorize_user!, only: %i[edit update destroy]

  # Load stats + genres only on index and show pages
  before_action :set_book_stats, only: %i[index show edit new]

  # --------------------------
  # Wishlist Actions
  # --------------------------

  def add_to_wishlist
    current_user.wishlist_books << @book unless current_user.wishlist_books.exists?(@book.id)
    redirect_back fallback_location: root_path
  end

  def remove_from_wishlist
    current_user.wishlist_books.delete(@book)
    redirect_back fallback_location: root_path
  end

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

      @finished_books   = @books.where(read: true)
      @current_read     = @books.where(currently_reading: true)
      @not_started      = @books.where(read: false, currently_reading: false)
      @wishlist_books   = current_user.wishlist_books
      @favorite_books   = @books.where(favorite: true)
      @sort_by_rating   = [ 1, 2, 3, 4, 5 ]
      @top_genre        = current_user.top_genre

      # ------ FILTERS -------
      @books          = apply_filters(@books)
      @finished_books = apply_filters(@finished_books)
      @current_read   = apply_filters(@current_read)
      @not_started    = apply_filters(@not_started)
      @favorite_books = apply_filters(@favorite_books)

    else
      @books = Book.none
    end
  end

  # --------------------------
  # SHOW
  # --------------------------

  def show
    @genres = @genres || current_user.books.pluck(:genre).uniq.sort
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

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to books_path, notice: "Book update successful."
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book deleted."
  end

  # --------------------------
  # Private / Helpers
  # --------------------------

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def authorize_user!
    redirect_to books_path, alert: "Not authorized." unless @book.user == current_user
  end

  def apply_filters(scope)
    scope = scope.where(genre: params[:genre]) if params[:genre].present?
    scope = scope.where(rating: params[:rating]) if params[:rating].present?
    scope
  end

  def set_book_stats
    if user_signed_in?
      books = current_user.books
      @total_books      = books.count
      @books_read       = books.where(read: true)
      @unread           = books.where(read: false)
      @total_pages_read = @books_read.sum(:total_pages)
      @average_rating   = @books_read.average(:rating)&.round(1) || 0
      @five_star_books  = books.where(rating: 5)
      @genres           = books.pluck(:genre).compact.uniq.sort
    end
  end

  def book_params
    params.require(:book).permit(
      :title, :author, :genre, :page_number, :total_pages,
      :read, :currently_reading, :rating, :favorite
    )
  end
end
