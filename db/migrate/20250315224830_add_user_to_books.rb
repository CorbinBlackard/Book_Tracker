class AddUserToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :user, foreign_key: true, null: true # Allow NULL temporarily

    # Assign all existing books to a default user (or set to NULL)
    reversible do |dir|
      dir.up do
        default_user = User.first || User.create!(email: "default@example.com", password: "password")
        Book.update_all(user_id: default_user.id)
        change_column_null :books, :user_id, false # Now enforce NOT NULL
      end
    end
  end
end
