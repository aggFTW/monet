class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.time :schedule
      t.string :days
      t.references :schoolyear

      t.timestamps
    end
  end
end
