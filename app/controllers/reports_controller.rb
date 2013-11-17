#encoding: utf-8
class ReportsController < ApplicationController

	before_filter :authenticate_user

	def incomeStatementYear
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				@incomeStatement = incomeStatement(schoolyear)
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




	#accountancy calculations

	def incomeStatement(schoolyear)
		incomeStatement = Hash.new

		incomeStatement[:name] = "Estado de resultados para el ciclo escolar " + schoolyear.name
		incomeStatement[:totalStudents] = countStudentsPerSchoolyear(schoolyear)

		incomeStatement[:incomeInscriptions] = incomeStatement[:totalStudents] * schoolyear.stdInscription
		incomeStatement[:incomeMaterial] = incomeStatement[:totalStudents] * schoolyear.stdMaterial
		incomeStatement[:incomeTuition] = incomeStatement[:totalStudents] * schoolyear.stdTuition
		incomeStatement[:incomeExposition] = incomeStatement[:totalStudents] * schoolyear.stdExposition

		incomeStatement[:discountInscriptions] = discountInscriptions(schoolyear)
		incomeStatement[:discountMaterial] = discountMaterial(schoolyear)
		incomeStatement[:discountTuition] = discountTuition(schoolyear)
		incomeStatement[:discountExposition] = discountExposition(schoolyear)

		incomeStatement[:notPayed] = notPayedTotal(schoolyear)

		exps = expenses(schoolyear)
		incomeStatement[:expensesRent] = exps[:rent]
		incomeStatement[:expensesServices] = exps[:services]
		incomeStatement[:expensesMaterial] = exps[:material]
		incomeStatement[:expensesSalaries] = exps[:salaries]
		incomeStatement[:expensesTaxes] = exps[:taxes]
		incomeStatement[:expensesOther] = exps[:other]

		return incomeStatement
	end



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



	def notPayedTotal(schoolyear)
		students = schoolyear.groups.map { |g| g.students }.flatten

		notPayedThreeLayers = students.map { |s| notPayedStudentYear(s, schoolyear) }
		notPayedOneLayer = []
		notPayedThreeLayers.each{ |e| e.each{ |f| notPayedOneLayer << f } }

		return notPayedOneLayer.map { |e| e[2] }.inject(0, :+)
	end

	def notPayedStudentYear(student, schoolyear)
		return notPayedStudent(student).keep_if{ |chargeTrio| chargeTrio[1].datedue <= schoolyear.end && chargeTrio[1].datedue >= schoolyear.beginning }
	end

	def notPayedStudent(student)
		rv = []

		# Charges with at least one payment but less different than expected
		payments = Payment.where("student_id = ?", student.id).select("id as id, student_id as student_id, max(dateof) as dateof, sum(amount) as amount, '' as comment, charge_id as charge_id").group("charge_id").all
		rv = rv.concat(payments.keep_if { |p| p.amount != p.charge.amount }.map { |p| [student.id, p.charge, p.charge.amount - p.amount] })

		# Charges with no payments made
		missing = student.charges - rv.map { |p| p[1] }
		missing = missing.map { |c| [student.id, c, c.amount] }

		rv = rv.concat( missing )

		# Returns an array of arrays of the form : [student_id, Charge, amount owed]
		return rv
	end



	def expenses(schoolyear)
		exps = expensesByDate(schoolyear.beginning, schoolyear.end)

		rv = Hash.new
		rv[:rent] = exps.keep_if { |e| e.etype == "Renta" }.map { |e| e.amount }.inject(0, :+)
		rv[:services] = exps.keep_if { |e| e.etype == "Servicios" }.map { |e| e.amount }.inject(0, :+)
		rv[:material] = exps.keep_if { |e| e.etype == "Material" }.map { |e| e.amount }.inject(0, :+)
		rv[:salaries] = exps.keep_if { |e| e.etype == "Sueldos" }.map { |e| e.amount }.inject(0, :+)
		rv[:taxes] = exps.keep_if { |e| e.etype == "Impuestos" }.map { |e| e.amount }.inject(0, :+)
		rv[:other] = exps.keep_if { |e| e.etype == "Otro" }.map { |e| e.amount }.inject(0, :+)

		return rv
	end

	def expensesByDate(startDate, endDate)
		return Expense.where("dateof >= :startDate AND dateof <= :endDate", {startDate: startDate, endDate: endDate}).all
	end










	#helpers

	def toDate(year, month)
		Date.strptime("{ %d, %d, %d }" % [year, month, 1], "{ %Y, %m, %d }")
	end

	def getSchoolyear(startMonth, endMonth, startYear, endYear)
		startDate = toDate(startYear, startMonth)
		endDate = toDate(endYear, endMonth)

		Schoolyear.where("beginning >= :startDate AND end <= :endDate", {startDate: startDate, endDate: endDate})
	end

	def validDates(startMonth, endMonth, startYear, endYear)
		if startYear > endYear
			return false
		end

		if startYear == endYear
			if startMonth > endMonth
				return false
			end
		end

		return true
	end

	def countStudentsPerSchoolyear(schoolyear)
		return schoolyear.groups.map { |g| g.students }.flatten.length
	end

end