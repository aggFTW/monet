#encoding: utf-8
class EmployeesController < ApplicationController

	def index
		if check_admin
			@employees = Employee.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@employee = Employee.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	# def regnew
	# 	if check_admin
	# 		@employee = Employee.new
	# 	else
	# 		flash[:error] = "Acceso restringido."
	# 		redirect_to(root_path)
	# 	end
	# end

	def create
		if check_admin
			@employee = Employee.new(params[:employee])
		
			if @employee.save
				flash[:notice] = "La persona tiene ahora un nuevo rol como empleado."
				reset_env_vars
				redirect_to controller: :employees, action: :index
			else
				flash[:error] = "Sus datos no son válidos."
				redirect_to controller: :employees, action: :new
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@employee = Employee.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@employee = Employee.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@employee = Employee.find(params[:id])
		 
			if @employee.update_attributes(params[:employee])
				flash[:notice] = 'El empleado fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del empleado."
		    end

		    redirect_to(@employee)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@employee = Employee.find(params[:id])
			@employee.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def selectMonthlyList
		if check_admin
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def monthlyList
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				if params[:month] != nil
					@month = params[:month]
					@classis = monthList(schoolyear, params[:month].to_i)
				else
					@month = ""
					@classis = currentMonthList(schoolyear)
				end
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar al estado de resultados o abra un ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	# Helpers - I hate Rails

	def currentMonthList(schoolyear)
		return monthList(schoolyear, Date.today.month)
	end

	def monthList(schoolyear, month)
		firstDay = toDate(schoolyear.yearForMonth(month), month)
		lastDay = toDateLastDay(schoolyear.yearForMonth(month), month)

		return Classi.where("dateof >= :firstDay AND dateof <= :lastDay", {firstDay: firstDay, lastDay: lastDay}).all
	end

	def toDate(year, month)
		Date.strptime("{ %d, %d, %d }" % [year, month, 1], "{ %Y, %m, %d }")
	end

	def toDateLastDay(year, month)
		Date.civil(year, month, -1)
	end
end
