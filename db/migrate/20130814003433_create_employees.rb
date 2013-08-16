class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :role
      t.float :salary
      t.references :person

      t.timestamps
    end
  end
end
