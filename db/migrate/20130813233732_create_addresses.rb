class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :number
      t.string :street
      t.string :neighborhood
      t.string :zip
      t.string :interior

      t.timestamps
    end
  end
end
