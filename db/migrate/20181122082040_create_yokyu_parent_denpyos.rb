class CreateYokyuParentDenpyos < ActiveRecord::Migration[5.2]
  def change
    create_table :yokyu_parent_denpyos do |t|
      t.text :content
      t.integer :flag
      t.references :yokyu_parent, foreign_key: true

      t.timestamps
    end
    add_index :yokyu_parent_denpyos, [:flag, :yokyu_parent_id]
  end
end
