class BooksController < ApplicationController
  # Before running certain actions, find the book based on the ID in the URL
  before_action :set_book, only: %i[show edit update destroy]

  # Display a list of all books, along with the finished and currently reading books
  def index
    @books = Book.all
    @finished_books = Book.where(read: true)  # Books marked as 'read'
    @current_read = Book.where(read: false)   # Books that are still being read
    @finished_books_count = Book.finished_books_count  # Total count of finished books
  end

  # Show the details of a single book
  def show
    # No need to define any logic here, as @book is already set by set_book before this action
  end

  # Initialize a new empty book object for the form
  def new
    @book = Book.new
  end

  # Create a new book from the form input, then save it to the database
  def create
    @book = Book.new(book_params)
    if @book.save
      # If saved successfully, redirect to the book's show page with a success notice
      redirect_to @book, notice: "Book was successfully created."
    else
      # If validation fails, render the 'new' page again to show error messages
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
      # If update is successful, redirect to the book's show page with a success notice
      redirect_to @book, notice: "Book was successfully updated."
    else
      # If update fails, render the 'edit' page again to show validation errors
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
    # Ensure both total_pages and page_number are present to avoid division by zero
    return 0 unless @book.total_pages && @book.page_number

    # Calculate the percentage progress
    (@book.page_number.to_f / @book.total_pages.to_f) * 100
  end

  private

  # Set the book instance variable before certain actions (show, edit, update, destroy)
  def set_book
    @book = Book.find(params[:id])
  end

  # Strong parameters to whitelist the fields allowed for creating or updating a book
  def book_params
    params.require(:book).permit(:title, :author, :genre, :page_number, :read, :rating, :total_pages)
  end
end
