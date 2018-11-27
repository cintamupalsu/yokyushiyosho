class CreateCompanyTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :company_types do |t|
      t.string :name
      t.boolean :client
      t.integer :flag
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
