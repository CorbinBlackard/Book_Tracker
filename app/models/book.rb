class Book < ApplicationRecord
    # Validations
    validates :title, presence: true
    validates :author, presence: true
    validates :genre, presence: true
    validates :page_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
    validates :rating, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
    belongs_to :user

    # Instance Methods
    # Method to calculate the progress percentage
    def progress_percentage
        return 0 if total_pages == 0 # Prevent division by zero

        # Calculate and return the percentage of pages read
        ((page_number.to_f / total_pages) * 100).round(2)
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
end
