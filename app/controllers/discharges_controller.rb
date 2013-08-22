#encoding: utf-8
class DischargesController < ApplicationController
	def index
		if check_admin
			@discharges = Discharge.order(:student_id).order(:dateof)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@discharge = Discharge.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@discharge = Discharge.new(params[:discharge])
		
			if @discharge.save
				flash[:notice] = "Se ha dado de baja al alumno."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(discharges_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@discharge = Discharge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@discharge = Discharge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@discharge = Discharge.find(params[:id])
		 
			if @discharge.update_attributes(params[:discharge])
				flash[:notice] = 'Los datos de la baja fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos de la baja."
		    end

		    redirect_to(@discharge)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@discharge = Discharge.find(params[:id])
			@discharge.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
