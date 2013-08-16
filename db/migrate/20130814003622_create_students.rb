class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :school
      t.float :sInscription
      t.float :sMaterial
      t.float :sExposition
      t.float :sTuition
      t.string :sType
      t.references :person

      t.timestamps
    end
  end
end
