class CreateYokyuChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :yokyu_children do |t|
      t.string :name
      t.string :default_col
      t.integer :flag
      t.references :user, foreign_key: true
      t.references :yokyu_parent, foreign_key: true

      t.timestamps
    end
    add_index :yokyu_children, [:flag, :user_id, :yokyu_parent_id]
  end
end
