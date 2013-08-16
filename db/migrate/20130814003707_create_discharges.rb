class CreateDischarges < ActiveRecord::Migration
  def change
    create_table :discharges do |t|
      t.date :dateof
      t.string :reason
      t.references :student

      t.timestamps
    end
  end
end
