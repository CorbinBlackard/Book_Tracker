class AddTotalPagesToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :total_pages, :integer
  end
end
