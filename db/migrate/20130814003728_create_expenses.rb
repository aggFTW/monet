class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.text :description
      t.date :dateof
      t.float :amount
      t.string :type
      t.references :employee

      t.timestamps
    end
  end
end
