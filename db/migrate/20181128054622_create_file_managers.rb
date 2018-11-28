class CreateFileManagers < ActiveRecord::Migration[5.2]
  def change
    create_table :file_managers do |t|
      t.string :name
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :file_managers, [:user_id, :created_at]
  end
end
