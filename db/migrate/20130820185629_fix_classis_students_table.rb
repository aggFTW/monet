class FixClassisStudentsTable < ActiveRecord::Migration
  def change
  	rename_table :students_classis, :classis_students
  end
end
