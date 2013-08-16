class CreateMany < ActiveRecord::Migration
  def change
    
	# ?? Sibling s1:reference s2:reference
	create_table :people_people do |t|
      t.belongs_to :person
      t.belongs_to :person
    end

	# ?? Topay student:reference charge:reference
	create_table :students_charges do |t|
      t.belongs_to :student
      t.belongs_to :charge
    end

	# ?? Sassistance student:reference classi:reference
	create_table :students_classis do |t|
      t.belongs_to :student
      t.belongs_to :classi
    end

	# ?? Workswith employee:reference group:reference
	create_table :employees_groups do |t|
      t.belongs_to :employee
      t.belongs_to :group
    end

	# ?? Registration student:reference group:reference
  	create_table :students_groups do |t|
      t.belongs_to :student
      t.belongs_to :group
    end


	# ?? Eassistance payed:date employee:reference classi:reference
    create_table :eassistance do |t|
      t.belongs_to :employee
      t.belongs_to :classi
      t.date :payed
      t.timestamps
    end

  end
end
