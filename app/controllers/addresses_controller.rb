#encoding: utf-8
class AddressesController < ApplicationController

	def index
		if check_admin
			@addresses = Address.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@address = Address.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@address = Address.new(params[:address])
		
			if @address.save!
				flash[:notice] = "Se creó exitosamente el domicilio."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(addresses_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@address = Address.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@address = Address.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@address = Address.find(params[:id])
		 
			if @address.update_attributes(params[:address])
				flash[:notice] = 'El domicilio fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del domicilio."
		    end

		    redirect_to(@address)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@address = Address.find(params[:id])
			@address.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

end
