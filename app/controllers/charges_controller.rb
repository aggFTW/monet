#encoding: utf-8
class ChargesController < ApplicationController
	def index
		if check_admin
			@charges = Charge.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@charge = Charge.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@charge = Charge.new(params[:charge])
		
			if @charge.save
				flash[:notice] = "Se ha creado un nuevo cargo."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(charges_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@charge = Charge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@charge = Charge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@charge = Charge.find(params[:id])
		 
			if @charge.update_attributes(params[:charge])
				flash[:notice] = 'Los datos del cargo fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del cargo."
		    end

		    redirect_to(@charge)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@charge = Charge.find(params[:id])
			@charge.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
