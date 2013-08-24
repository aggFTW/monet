#encoding: utf-8
class ClassisController < ApplicationController

	def index
		if check_admin
			@classis = Classi.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@classi = Classi.new
			# @classi.eassistances.build.build_
			# @employees = Employee.find(:all, :limit => 2)
			# 3.times { @classi.employees.build }
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@classi = Classi.new(params[:classi])
		
			if @classi.save!
				flash[:notice] = "Se ha tomado lista."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(classis_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@classi = Classi.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@classi = Classi.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@classi = Classi.find(params[:id])
		 
			if @classi.update_attributes(params[:classi])
				flash[:notice] = 'Los datos de la asistencia fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del gasto."
		    end

		    redirect_to(@classi)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@classi = Classi.find(params[:id])
			@classi.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

end
