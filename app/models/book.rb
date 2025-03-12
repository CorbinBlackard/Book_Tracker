class Book < ApplicationRecord
    validates :title, presence: true
    validates :author, presence: true
    validates :genre, presence: true
    validates :page_number, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true
    validates :rating, inclusion: { in: 1..5, message: "must be between 1 and 5" }, allow_nil: true
    def percentage_completed
        if total_pages.present? && page_number.present?
        [ (page_number.to_f / total_pages.to_f) * 100, 100 ].min
        else
            0
        end
    end
    def self.finished_books_count
        where(read: true).count
    end
end
