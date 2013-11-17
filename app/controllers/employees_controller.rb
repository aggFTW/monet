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

end
