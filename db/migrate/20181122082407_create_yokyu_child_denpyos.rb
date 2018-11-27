class CreateYokyuChildDenpyos < ActiveRecord::Migration[5.2]
  def change
    create_table :yokyu_child_denpyos do |t|
      t.text :content
      t.integer :flag
      t.references :yokyu_parent_denpyo, foreign_key: true
      t.references :yokyu_child, foreign_key: true

      t.timestamps
    end
    add_index :yokyu_child_denpyos, [:flag, :yokyu_parent_denpyo_id]
  end
end
