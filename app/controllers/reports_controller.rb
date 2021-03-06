#encoding: utf-8
class ReportsController < ApplicationController

	before_filter :authenticate_user

	STARTMONTH = 9
	ENDMONTH = 7
	EXPOMONTH = 6
	YEARNORMALIZED = 2000

	def selectMonthlyIS
		if check_admin
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def selectDailyStatement
		if check_admin
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def incomeStatementYear
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				@incomeStatement = yearIS(schoolyear)
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar al estado de resultados o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def incomeStatementMonth
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				if params[:month] != nil
					@incomeStatement = monthIS(schoolyear, params[:month].to_i)
				else
					@incomeStatement = currentMonthIS(schoolyear)
				end
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar al estado de resultados o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def incomeStatementDay
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				
				if params[:day] != nil
					day = Date.strptime(params[:day], "%Y-%m-%d")
					@incomeStatement = todayIS(schoolyear, day)
				else
					@incomeStatement = todayIS(schoolyear, Date.today)
				end
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar al estado de resultados o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def error
		if check_admin
			@message = params[:message]
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def notPayedSchoolyear
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				
				@latePayments = notPayedDates(schoolyear, schoolyear.beginning, schoolyear.end)
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar a las cuentas por cobrar de este ciclo o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)			
		end
	end

	def paymentsStudent
		if check_admin
			@student = Student.find(params[:student_id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def birthdaysMonth
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				month = Date.today.month
				year = Date.today.year
				@birthdays = birthdaysByDates(schoolyear, toDate(year, month), toDateLastDay(year, month))
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar a las cuentas por cobrar de este ciclo o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def birthdaysYear
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first

				@birthdays = birthdaysByDates(schoolyear, toDate(Date.today.year, 1), toDateLastDay(Date.today.year, 12))
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar a las cuentas por cobrar de este ciclo o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end







	#accountancy calculations
	def yearIS(schoolyear)
		incomeStatement = Hash.new
		firstDay = schoolyear.beginning
		lastDay = schoolyear.end

		incomeStatement[:name] = "Estado de resultados para el ciclo escolar " + schoolyear.name
		incomeStatement[:totalStudents] = schoolyear.groups.map{ |g| g.activeStudents.length }.inject(0, :+)

		pays = payments(firstDay, lastDay)
		incomeStatement[:incomeInscriptions] = pays[:inscription]
		incomeStatement[:incomeMaterial] = pays[:material]
		incomeStatement[:incomeTuition] = pays[:tuition]
		incomeStatement[:incomeExposition] = pays[:exposition]
		incomeStatement[:incomeOther] = pays[:other]

		incomeStatement[:notPayed] = notPayedDates(schoolyear, firstDay, lastDay).map { |e| e[2] }.inject(0, :+)

		exps = expenses(firstDay, lastDay)
		incomeStatement[:expensesRent] = exps[:rent]
		incomeStatement[:expensesServices] = exps[:services]
		incomeStatement[:expensesMaterial] = exps[:material]
		incomeStatement[:expensesSalaries] = exps[:salaries]
		incomeStatement[:expensesTaxes] = exps[:taxes]
		incomeStatement[:expensesOther] = exps[:other]

		# Estimated part (not dependable)
		incomeStatement[:estimatedIncomeInscriptions] = estIncomeInscriptions(schoolyear)
		incomeStatement[:estimatedIncomeMaterial] = estIncomeMaterial(schoolyear)
		incomeStatement[:estimatedIncomeExposition] = estIncomeExposition(schoolyear)
		incomeStatement[:estimatedIncomeTuition] = estIncomeTuition(schoolyear) * 10

		incomeStatement[:discountInscriptions] = discountInscriptions(schoolyear)
		incomeStatement[:discountMaterial] = discountMaterial(schoolyear)
		incomeStatement[:discountExposition] = discountExposition(schoolyear)
		incomeStatement[:discountTuition] = discountTuition(schoolyear) * 10

		return incomeStatement
	end

	def currentMonthIS(schoolyear)
		month = Time.now.month
		return monthIS(schoolyear, month)
	end

	def monthIS(schoolyear, month)
		incomeStatement = Hash.new
		yearMonth = schoolyear.yearForMonth(month)
		firstDay = toDate(yearMonth, month)
		lastDay = toDateLastDay(yearMonth, month)

		incomeStatement[:name] = "Estado de resultados para el mes " + month.to_s
		incomeStatement[:totalStudents] = schoolyear.groups.map{ |g| g.activeStudentsInMonth(month).length }.inject(0, :+)

		pays = payments(firstDay, lastDay)
		incomeStatement[:incomeInscriptions] = pays[:inscription]
		incomeStatement[:incomeMaterial] = pays[:material]
		incomeStatement[:incomeTuition] = pays[:tuition]
		incomeStatement[:incomeExposition] = pays[:exposition]
		incomeStatement[:incomeOther] = pays[:other]

		incomeStatement[:notPayed] = notPayedDates(schoolyear, firstDay, lastDay).map { |e| e[2] }.inject(0, :+)

		exps = expenses(firstDay, lastDay)
		incomeStatement[:expensesRent] = exps[:rent]
		incomeStatement[:expensesServices] = exps[:services]
		incomeStatement[:expensesMaterial] = exps[:material]
		incomeStatement[:expensesSalaries] = exps[:salaries]
		incomeStatement[:expensesTaxes] = exps[:taxes]
		incomeStatement[:expensesOther] = exps[:other]

		# Estimated part (not dependable)
		if month == STARTMONTH
			incomeStatement[:estimatedIncomeInscriptions] = estIncomeInscriptions(schoolyear)
			incomeStatement[:estimatedIncomeMaterial] = estIncomeMaterial(schoolyear)
		else
			incomeStatement[:estimatedIncomeInscriptions] = 0
			incomeStatement[:estimatedIncomeMaterial] = 0
		end

		if month == EXPOMONTH
			incomeStatement[:estimatedIncomeExposition] = estIncomeExposition(schoolyear)
		else
			incomeStatement[:estimatedIncomeExposition] = 0
		end

		incomeStatement[:estimatedIncomeTuition] = estIncomeTuition(schoolyear)

		incomeStatement[:discountInscriptions] = discountInscriptions(schoolyear)
		incomeStatement[:discountMaterial] = discountMaterial(schoolyear)
		incomeStatement[:discountTuition] = discountTuition(schoolyear)
		incomeStatement[:discountExposition] = discountExposition(schoolyear)

		return incomeStatement
	end

	def todayIS(schoolyear, today)
		incomeStatement = Hash.new

		incomeStatement[:name] = "Transacciones del día " + today.strftime("%d %B, %Y")

		incomeStatement[:payments] = Payment.where("dateof >= :startDate AND dateof <= :endDate", {startDate: today, endDate: today}).all
		pays = payments(today, today)
		incomeStatement[:incomeInscriptions] = pays[:inscription]
		incomeStatement[:incomeMaterial] = pays[:material]
		incomeStatement[:incomeTuition] = pays[:tuition]
		incomeStatement[:incomeExposition] = pays[:exposition]
		incomeStatement[:incomeOther] = pays[:other]

		incomeStatement[:expenses] = Expense.where("dateof >= :startDate AND dateof <= :endDate", {startDate: today, endDate: today}).all
		exps = expenses(today, today)
		incomeStatement[:expensesRent] = exps[:rent]
		incomeStatement[:expensesServices] = exps[:services]
		incomeStatement[:expensesMaterial] = exps[:material]
		incomeStatement[:expensesSalaries] = exps[:salaries]
		incomeStatement[:expensesTaxes] = exps[:taxes]
		incomeStatement[:expensesOther] = exps[:other]

		return incomeStatement
	end




	#######################################################################################################################
	#######################################################################################################################
	#######################################################################################################################

	# Payments
	def payments(startDate, endDate)
		pays = Payment.where("dateof >= :startDate AND dateof <= :endDate", {startDate: startDate, endDate: endDate}).all

		rv = Hash.new
		rv[:inscription] = pays.keep_if { |p| p.charge.ctype == "Inscripcion" }.map { |e| e.amount }.inject(0, :+)
		rv[:tuition] = pays.keep_if { |p| p.charge.ctype == "Colegiatura" }.map { |e| e.amount }.inject(0, :+)
		rv[:exposition] = pays.keep_if { |p| p.charge.ctype == "Exposicion" }.map { |e| e.amount }.inject(0, :+)
		rv[:material] = pays.keep_if { |p| p.charge.ctype == "Material" }.map { |e| e.amount }.inject(0, :+)
		rv[:other] = pays.keep_if { |p| p.charge.ctype == "Otro" }.map { |e| e.amount }.inject(0, :+)
		    
		return rv
	end

	# Estimated Income
	def estIncomeInscriptions(schoolyear)
		return schoolyear.groups.map { |g| g.students }.flatten.length * schoolyear.stdInscription
	end 

	def estIncomeMaterial(schoolyear)
		return schoolyear.groups.map { |g| g.students }.flatten.length * schoolyear.stdMaterial
	end 

	def estIncomeTuition(schoolyear)
		return schoolyear.groups.map { |g| g.students }.flatten.length * schoolyear.stdTuition
	end 

	def estIncomeExposition(schoolyear)
		return schoolyear.groups.map { |g| g.students }.flatten.length * schoolyear.stdExposition
	end

	# Expenses
	def expenses(startDate, endDate)
		exps = Expense.where("dateof >= :startDate AND dateof <= :endDate", {startDate: startDate, endDate: endDate}).all

		rv = Hash.new
		rv[:rent] = exps.keep_if { |e| e.etype == "Renta" }.map { |e| e.amount }.inject(0, :+)
		rv[:services] = exps.keep_if { |e| e.etype == "Servicios" }.map { |e| e.amount }.inject(0, :+)
		rv[:material] = exps.keep_if { |e| e.etype == "Material" }.map { |e| e.amount }.inject(0, :+)
		rv[:salaries] = exps.keep_if { |e| e.etype == "Sueldos" }.map { |e| e.amount }.inject(0, :+)
		rv[:taxes] = exps.keep_if { |e| e.etype == "Impuestos" }.map { |e| e.amount }.inject(0, :+)
		rv[:other] = exps.keep_if { |e| e.etype == "Otro" }.map { |e| e.amount }.inject(0, :+)

		return rv
	end

	# Not payed
	def notPayedDates(schoolyear, startDate, endDate)
		students = schoolyear.groups.map { |g| g.students }.flatten

		notPayedThreeLayers = students.map { |s| notPayedStudentDates(s, startDate, endDate) }

		notPayedOneLayer = []
		notPayedThreeLayers.each{ |e| e.each{ |f| notPayedOneLayer << f } }

		return notPayedOneLayer
	end

	def notPayedStudentDates(student, startDate, endDate)
		return notPayedStudent(student).keep_if{ |chargeTrio| chargeTrio[1].datedue <= endDate && chargeTrio[1].datedue >= startDate }
	end

	def notPayedStudent(student)
		rv = []

		# Charges with at least one payment but total different than expected
		payments = Payment.where("student_id = ?", student.id).select("id as id, student_id as student_id, max(dateof) as dateof, sum(amount) as amount, '' as comment, charge_id as charge_id").group("charge_id").all
		rv = rv.concat(payments.keep_if { |p| p.amount != p.charge.amount }.map { |p| [student.id, p.charge, p.charge.amount - p.amount] })

		# Charges with no payments made
		missing = student.charges - rv.map { |p| p[1] }
		missing = missing.map { |c| [student.id, c, c.amount] }

		rv = rv.concat( missing )

		# Returns an array of arrays of the form : [student_id, Charge, amount owed]
		return rv
	end

	# Discounts
	def discountInscriptions(schoolyear)
		students = schoolyear.groups.map { |g| g.students }.flatten.keep_if { |s| s.sInscription != 0 }

		return students.map { |s| schoolyear.stdInscription - s.sInscription }.inject(0, :+)
	end 

	def discountMaterial(schoolyear)
		students = schoolyear.groups.map { |g| g.students }.flatten.keep_if { |s| s.sMaterial != 0 }

		return students.map { |s| schoolyear.stdMaterial - s.sMaterial }.inject(0, :+)
	end 

	def discountTuition(schoolyear)
		students = schoolyear.groups.map { |g| g.students }.flatten.keep_if { |s| s.sTuition != 0 }

		return students.map { |s| schoolyear.stdTuition - s.sTuition }.inject(0, :+)
	end 

	def discountExposition(schoolyear)
		students = schoolyear.groups.map { |g| g.students }.flatten.keep_if { |s| s.sExposition != 0 }

		return students.map { |s| schoolyear.stdExposition - s.sExposition }.inject(0, :+)
	end

	# Birthdays
	def birthdaysByDates(schoolyear, startDate, endDate)
		rv = schoolyear.groups.map { |g| g.students }.flatten.uniq.keep_if{ |s| normalizeYear(s.person.dob) <= normalizeYear(endDate) && normalizeYear(s.person.dob) >= normalizeYear(startDate) }

		# Add people who were born on Feb 29th
		if wouldContainFeb29(startDate, endDate)
			rv += schoolyear.groups.map { |g| g.students }.flatten.uniq.keep_if{ |s| normalizeYear(s.person.dob) == toDateLastDay(YEARNORMALIZED, 2) }
		end

		return rv.uniq
	end

	def normalizeYear(date)
		return Date.strptime("{ %d, %d, %d }" % [YEARNORMALIZED, date.month, date.day], "{ %Y, %m, %d }")
	end

	def wouldContainFeb29(startDate, endDate)
		startDate = normalizeYear(startDate)
		endDate = normalizeYear(endDate)
		feb29 = toDateLastDay(2000, 2)

		return endDate == feb29 - 1 ||  (startDate <= feb29 && endDate >= feb29)
	end

	def toDate(year, month)
		Date.strptime("{ %d, %d, %d }" % [year, month, 1], "{ %Y, %m, %d }")
	end

	def toDateLastDay(year, month)
		Date.civil(year, month, -1)
	end
end