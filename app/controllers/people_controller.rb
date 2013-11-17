#encoding: utf-8
class PeopleController < ApplicationController

	def index
		if check_admin
			@people = Person.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@person = Person.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def regdadnew
		if check_admin
			@person = Person.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def regmomnew
		if check_admin
			@person = Person.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def regemployee
		if check_admin
			@person = Person.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin

			if params[:commit] == "regdad"

				@person = Person.new(params[:person])
		
				if @person.save
					flash[:notice] = "Papá creado de manera exitosa."
					session[:dad_id] = @person.id
					redirect_to action: :regmomnew, controller: :people
				else
					flash[:error] = "Sus datos no son válidos."
					redirect_to action: :regdadnew, controller: :people
				end
			
			elsif params[:commit] == "regmom"

				@person = Person.new(params[:person])
		
				if @person.save
					flash[:notice] = "Mamá creada de manera exitosa."
					session[:mom_id] = @person.id
					redirect_to action: :regnew, controller: :students
				else
					flash[:error] = "Sus datos no son válidos."
					redirect_to action: :regmomnew, controller: :people
				end

			elsif params[:commit] == "regemployee"

				@person = Person.new(params[:person])
		
				if @person.save
					flash[:notice] = "Datos de empleado guardados."
					session[:employee_person_id] = @person.id
					redirect_to action: :new, controller: :employees
				else
					flash[:error] = "Sus datos no son válidos."
					redirect_to action: :regemployee, controller: :people
				end			

			else

				@person = Person.new(params[:person])
			
				if @person.save
					flash[:notice] = "Persona creada de manera exitosa."
				else
					flash[:error] = "Sus datos no son válidos."
				end

				redirect_to(people_path)

			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin || @current_user.id.to_s == params[:id]
			@person = Person.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin || @current_user.id.to_s == params[:id]
			@person = Person.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin || @current_user.id.to_s == params[:id]
			@person = Person.find(params[:id])
		 
			if @person.update_attributes(params[:person])
				flash[:notice] = 'La persona fue actualizada de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos de la persona."
		    end

		    redirect_to(@person)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@person = User.find(params[:id])
			@person.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
