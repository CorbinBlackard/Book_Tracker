class AddReadAndPageNumberToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :read, :boolean
    add_column :books, :page_number, :integer
  end
end
