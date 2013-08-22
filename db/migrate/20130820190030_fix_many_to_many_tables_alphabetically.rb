class FixManyToManyTablesAlphabetically < ActiveRecord::Migration
  def change
  	rename_table :students_charges, :charges_students
  	rename_table :students_groups, :groups_students
  end
end
