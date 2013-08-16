class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :fname
      t.string :lname
      t.date :dob
      t.string :sex
      t.string :cellr
      t.string :email
      t.references :dad
      t.references :mom
      t.references :address

      t.timestamps
    end
  end
end
