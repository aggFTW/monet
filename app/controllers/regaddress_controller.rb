#encoding: utf-8
class RegaddressController < ApplicationController
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
		
			if @address.save
				flash[:notice] = "Se creó exitosamente el domicilio."
				session[:address_id] = @address.id
				redirect_to("regdad#new")
			else
				flash[:error] = "Sus datos no son válidos."
				redirect_to("regaddress#new")
			end
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
