class CreateWatsonLanguageMasters < ActiveRecord::Migration[5.2]
  def change
    create_table :watson_language_masters do |t|
      t.text :content
      t.text :variant
      t.integer :anchor
      
      t.timestamps
    end
    add_index :watson_language_masters, [:content, :created_at]
  end
end
