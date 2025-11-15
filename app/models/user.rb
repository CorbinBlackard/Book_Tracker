class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable
  has_many :books, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :wishlists
  has_many :wishlist_books, through: :wishlists, source: :book

  def top_genre
    genre_counts = books.map { |b| b.genre.strip.capitalize }.tally
    genre_counts.max_by { |genre, count| count }&.first
  end
end
