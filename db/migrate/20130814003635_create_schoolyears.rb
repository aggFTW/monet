class CreateSchoolyears < ActiveRecord::Migration
  def change
    create_table :schoolyears do |t|
      t.string :name
      t.date :beginning
      t.date :end
      t.boolean :active

      t.timestamps
    end
  end
end
