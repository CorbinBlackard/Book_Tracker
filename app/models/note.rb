class Note < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates :content, presence: true
  # Scope to get only notes with content
  scope :with_content, -> { where.not(content: [ nil, "" ]) }
end
