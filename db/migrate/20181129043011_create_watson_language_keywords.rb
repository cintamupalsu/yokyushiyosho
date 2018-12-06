class CreateWatsonLanguageKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :watson_language_keywords do |t|
      t.string :keyword
      t.float :relevance
      
      t.references :watson_language_master, foreign_key: true

      t.timestamps
    end
    add_index :watson_language_keywords, [:keyword, :created_at]
  end
end
