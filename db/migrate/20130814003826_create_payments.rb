class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.date :dateof
      t.float :amount
      t.text :comment
      t.string :ptype
      t.references :student
      t.references :charge

      t.timestamps
    end
  end
end
