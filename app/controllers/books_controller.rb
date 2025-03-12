class BooksController < ApplicationController
    before_action :set_book, only: %i[show edit update destroy]

    def index
        @books = Book.all
        @finished_books = Book.where(read: true) || []
        @current_read = Book.where(read: false) || []
        @finished_books_count = Book.finished_books_count
    end

    def show
    end

    def new
      @book = Book.new
    end

    def create
      @book = Book.new(book_params)
      if @book.save
        redirect_to @book, notice: "Book was successfully created."
      else
        render :new
      end
    end

    def edit
        @book = Book.find(params[:id])
    end

    def update
      if @book.update(book_params)
        redirect_to @book, notice: "Book was successfully updated."
      else
        render :edit
      end
    end

    def destroy
        @book = Book.find(params[:id])
        @book.destroy
        redirect_to books_path, notice: "Book was successfully deleted."
    end

    private
        def set_book
            @book = Book.find(params[:id])
        end

        def book_params
            params.require(:book).permit(:title, :author, :genre, :page_number, :read, :rating, :total_pages)
        end
end
