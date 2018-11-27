class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :address
      t.integer :flag
      t.references :company_type, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
