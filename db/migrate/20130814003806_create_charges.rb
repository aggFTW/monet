class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :name
      t.date :datedue
      t.float :amount
      t.string :ctype

      t.timestamps
    end
  end
end
