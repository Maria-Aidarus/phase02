class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :ssn
      t.string :date_of_birth
      t.string :date
      t.string :phone
      t.string :role
      t.string :integer
      t.string :active
      t.string :boolean

      t.timestamps
    end
  end
end
