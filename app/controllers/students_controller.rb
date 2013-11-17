#encoding: utf-8
class StudentsController < ApplicationController

	def index
		if check_admin
			@students = Student.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@student = Student.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def regnew
		if check_admin
			@student = Student.new
			@student.build_person
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin

			if params[:commit] == "regsame"

				@student = Student.new(params[:student])
			
				if @student.save!
					flash[:notice] = "Hijo creado de manera exitosa."
					redirect_to action: :regnew, controller: :students
				else
					flash[:error] = "Sus datos no son válidos."
					redirect_to action: :regnew, controller: :students
				end

			elsif params[:commit] == "regnext"

				@student = Student.new(params[:student])
			
				if @student.save
					reset_env_vars
					flash[:notice] = "El proceso de registro ha concluido exitosamente."
					redirect_to controller: :students, action: :index

				else
					flash[:error] = "Sus datos no son válidos."
					redirect_to action: :regnew, controller: :students
				end

			else
				@student = Student.new(params[:student])
			
				if @student.save
					flash[:notice] = "Se registró a la persona como estudiante."
				else
					flash[:error] = "Sus datos no son válidos."
				end

				redirect_to(students_path)
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@student = Student.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@student = Student.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@student = Student.find(params[:id])
		 
			if @student.update_attributes(params[:student])
				flash[:notice] = 'El estudiante fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del estudiante."
		    end

		    redirect_to(@student)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@student = Student.find(params[:id])
			@student.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def charges_by_student
	  @charges = Student.find(params[:student_id]).charges
	end
end
