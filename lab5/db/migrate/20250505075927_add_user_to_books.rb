class AddUserToBooks < ActiveRecord::Migration[8.0]
  def change
    add_reference :books, :user, foreign_key: true
  end
end
