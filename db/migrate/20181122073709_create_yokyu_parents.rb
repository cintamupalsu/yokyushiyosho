class CreateYokyuParents < ActiveRecord::Migration[5.2]
  def change
    create_table :yokyu_parents do |t|
      t.string :name
      t.string :default_col
      t.integer :flag
      t.integer :default_set
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :yokyu_parents, [:flag, :user_id, :name]
  end
end
