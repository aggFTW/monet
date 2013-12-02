Rake::Task['db:reset'].invoke

addresses = Address.create([
	{ :number => "123", :street => "Professor St", :neighborhood => "Prof", :zip => 78000 },
	{ :number => "456", :street => "Other St", :neighborhood => "Other", :zip => 78001, :interior => 1 }
])

people = Person.create([
	# students
	{ :fname => "Student", :lname => "1" , :dob => "1990-01-01" , :sex => "m", :cellr => "(444) 123 4567", :email => "student1@monet.com", :address_id => 2 },
	{ :fname => "Student", :lname => "2" , :dob => "2000-02-29" , :sex => "f", :cellr => "(444) 123 4567", :email => "student2@monet.com", :address_id => 2 },
	{ :fname => "Student", :lname => "3" , :dob => "1992-03-31" , :sex => "m", :cellr => "(444) 123 4567", :email => "student3@monet.com", :address_id => 2 },
	{ :fname => "Student", :lname => "4" , :dob => "1994-12-31" , :sex => "f", :cellr => "(444) 123 4567", :email => "student4@monet.com", :address_id => 2 },
	{ :fname => "Student", :lname => "5" , :dob => "1996-04-24" , :sex => "m", :cellr => "(444) 123 4567", :email => "student5@monet.com", :address_id => 2 },
	{ :fname => "Student", :lname => "6" , :dob => "1989-01-01" , :sex => "f", :cellr => "(444) 123 4567", :email => "student6@monet.com", :address_id => 2 },
	# professors / admin
	{ :fname => "L", :lname => "Casa", :dob => "1960-01-01", :sex => "f", :cellr => "(444) 123 4567", :email => "l@monet.com", :address_id => 1 },
	{ :fname => "S", :lname => "Casa", :dob => "1990-01-19", :sex => "f", :cellr => "(444) 123 4567", :email => "s@monet.com", :address_id => 1 },
	{ :fname => "C", :lname => "Casa", :dob => "1970-03-20", :sex => "f", :cellr => "(444) 123 4567", :email => "c@monet.com", :address_id => 1 },
	# dads
	{ :fname => "Papa", :lname => "1", :dob => "1960-01-01", :sex => "m", :cellr => "(444) 123 4567", :email => "papa1@monet.com", :address_id => 2 },
	{ :fname => "Papa", :lname => "2", :dob => "1960-01-01", :sex => "m", :cellr => "(444) 123 4567", :email => "papa2@monet.com", :address_id => 2 },
	{ :fname => "Papa", :lname => "3", :dob => "1960-01-01", :sex => "m", :cellr => "(444) 123 4567", :email => "papa3@monet.com", :address_id => 2 },
	# moms
	{ :fname => "Mama", :lname => "1", :dob => "1960-01-01", :sex => "f", :cellr => "(444) 123 4567", :email => "mama1@monet.com", :address_id => 2 },
	{ :fname => "Mama", :lname => "2", :dob => "1960-01-01", :sex => "f", :cellr => "(444) 123 4567", :email => "mama2@monet.com", :address_id => 2 },
	{ :fname => "Mama", :lname => "3", :dob => "1960-01-01", :sex => "f", :cellr => "(444) 123 4567", :email => "mama3@monet.com", :address_id => 2 }
])
Person.find(1).dad = Person.find(10)
Person.find(1).mom = Person.find(13)
Person.find(2).dad = Person.find(10)
Person.find(2).mom = Person.find(13)

Person.find(3).dad = Person.find(11)
Person.find(3).mom = Person.find(14)
Person.find(4).dad = Person.find(11)
Person.find(4).mom = Person.find(14)

Person.find(5).dad = Person.find(12)
Person.find(5).mom = Person.find(15)
Person.find(6).dad = Person.find(12)
Person.find(6).mom = Person.find(15)

u = User.new({ :username => "l", :password => "prueba", :person_id => 7 })
u.utype = 1
u.save
u = User.new({ :username => "s", :password => "prueba", :person_id => 8 })
u.utype = 1
u.save
u = User.new({ :username => "papa1", :password => "prueba", :person_id => 10 })
u.utype = 0
u.save

schoolyears = Schoolyear.create([
	{ :name => "2013-2014", :beginning => "2013-09-01", :end => "2014-06-30", :stdTuition => 100, :stdTuitionSiblings => 80, :state => "Activo", :stdInscription => 100, :stdMaterial => 100, :stdExposition => 100 },
	{ :name => "2012-2013", :beginning => "2012-09-01", :end => "2013-06-30", :stdTuition => 100, :stdTuitionSiblings => 80, :state => "Cerrado", :stdInscription => 100, :stdMaterial => 100, :stdExposition => 100 }
])

students = Student.create([
	{ :school => "School", :sInscription => 0, :sMaterial => 0, :sExposition => 0, :sTuition => 0, :sType => "NA", :person_id => 1 },
	{ :school => "School", :sInscription => 80, :sMaterial => 80, :sExposition => 80, :sTuition => 80, :sType => "Economica", :person_id => 2 },
	{ :school => "School", :sInscription => 0, :sMaterial => 0, :sExposition => 0, :sTuition => 0, :sType => "NA", :person_id => 3 },
	{ :school => "School", :sInscription => 80, :sMaterial => 80, :sExposition => 80, :sTuition => 80, :sType => "Economica", :person_id => 4 },
	{ :school => "School", :sInscription => 0, :sMaterial => 0, :sExposition => 0, :sTuition => 0, :sType => "NA", :person_id => 5 },
	{ :school => "School", :sInscription => 80, :sMaterial => 80, :sExposition => 80, :sTuition => 80, :sType => "Economica", :person_id => 6 }
])

works = Work.create([
	{ :title => "Work1", :technique => "Oleo", :student_id => 1, :schoolyear_id => 1 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 1, :schoolyear_id => 1 },
	{ :title => "Work1", :technique => "Oleo", :student_id => 2, :schoolyear_id => 1 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 2, :schoolyear_id => 1 },
	{ :title => "Work1", :technique => "Oleo", :student_id => 3, :schoolyear_id => 1 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 3, :schoolyear_id => 1 },
	{ :title => "Work1", :technique => "Oleo", :student_id => 4, :schoolyear_id => 1 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 4, :schoolyear_id => 1 },
	{ :title => "Work1", :technique => "Oleo", :student_id => 5, :schoolyear_id => 1 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 5, :schoolyear_id => 1 },
	{ :title => "Work1", :technique => "Oleo", :student_id => 6, :schoolyear_id => 2 },
	{ :title => "Work2", :technique => "Acrilico", :student_id => 6, :schoolyear_id => 2 }
])

groups = Group.create([
	{ :name => "Monday 4", :schedule => "2000-01-01 16:30:00", :schoolyear_id => 1, :mo => true, :tu => false, :we => true, :th => false, :fr => true, :sa => false, :su => false },
	{ :name => "Tuesday 6", :schedule => "2000-01-01 18:00:00", :schoolyear_id => 1, :mo => false, :tu => true, :we => false, :th => true, :fr => false, :sa => false, :su => false }
])

g = Group.find(1)
g.students << Student.find(1)
g.students << Student.find(2)
g.students << Student.find(3)

g = Group.find(2)
g.students << Student.find(4)
g.students << Student.find(5)
g.students << Student.find(6)

#employees

#employees groups

#charges

#payments

#expenses

#classis

#classis students

#eassistances

#discharges

