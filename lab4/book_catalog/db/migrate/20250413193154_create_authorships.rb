class CreateAuthorships < ActiveRecord::Migration[8.0]
  def change
    create_table :authorships do |t|
      t.references :book, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
