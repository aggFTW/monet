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

	def create
		if check_admin
			@person = Person.new(params[:person])
		
			if @person.save
				flash[:notice] = "Persona creada de manera exitosa."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(people_path)
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
