class AuthorsController < ApplicationController
  before_action :set_book_stats, only: [ :show ]
  def show
    @name = params[:name]
    @books = Book.where(author: @name)
  end

  private

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
end
