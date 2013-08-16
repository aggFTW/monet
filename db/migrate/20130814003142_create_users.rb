class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.integer :utype
      t.string :password
      t.string :password_digest
      t.references :person

      t.timestamps
    end
  end
end
