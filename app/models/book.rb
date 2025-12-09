class Book < ApplicationRecord
  # Validations
  validates :title, presence: true
  validates :author, presence: true
  validates :genre, presence: true
  validates :page_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
  validates :rating, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :wishlists
  has_many :users_wishlist, through: :wishlists, source: :user

  # Instance Methods
  # Method to calculate the progress percentage
  def progress_percentage
      return 0 if total_pages == 0 and page_number == 0 # Prevent error if no page number inserted

      # Calculate and return the percentage of pages read
      ((page_number.to_f / total_pages.to_f) * 100).round(2)
  end

  # app/models/book.rb
  before_save :normalize_genre

  def normalize_genre
    return if genre.blank?
    self.genre = genre.strip.split.map(&:capitalize).join(" ")
  end

  # Class Methods
  # Method to count finished books (read: true)
  def self.finished_books_count
      where(read: true).count
  end

  def self.currently_reading
      where(currently_reading: true)
  end

  def self.currently_reading_count
      where(currently_reading: true).count
  end

  def self.favorite_books
    where(favorite: true)
  end
end
