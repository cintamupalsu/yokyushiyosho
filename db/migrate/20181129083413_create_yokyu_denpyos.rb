class CreateYokyuDenpyos < ActiveRecord::Migration[5.2]
  def change
    create_table :yokyu_denpyos do |t|
      t.text :content
      t.references :user, foreign_key: true
      t.references :yokyu_parent, foreign_key: true
      t.integer :hospital
      t.integer :vendor
      t.integer :child
      t.integer :parent
      t.references :file_manager, foreign_key: true
      t.references :watson_language_master, foreign_key: true


      t.timestamps
    end
    add_index :yokyu_denpyos, [:user_id, :created_at]
  end
end
