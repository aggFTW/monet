class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :title
      t.string :technique
      t.references :student
      t.references :cycle

      t.timestamps
    end
  end
end
