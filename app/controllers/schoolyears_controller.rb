#encoding: utf-8
class SchoolyearsController < ApplicationController

	def index
		if check_admin
			@schoolyearsA = Schoolyear.where(state: 'Activo')
			@schoolyearsC = Schoolyear.where(state: 'Cerrado')
			@schoolyearsI = Schoolyear.where(state: 'Inscripciones')
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@schoolyear = Schoolyear.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def create
		if check_admin
			@schoolyear = Schoolyear.new(params[:schoolyear])
		
			if noConflictStates(-1, params[:schoolyear][:state]) and @schoolyear.save
				flash[:notice] = "El ciclo escolar ha sido guardado."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(schoolyears_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def show
		if check_admin
			@schoolyear = Schoolyear.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@schoolyear = Schoolyear.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@schoolyear = Schoolyear.find(params[:id])
		 
			if noConflictStates(params[:id], params[:schoolyear][:state]) and @schoolyear.update_attributes(params[:schoolyear])
				flash[:notice] = 'El ciclo escolar fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del ciclo escolar."
		    end

		    redirect_to(@schoolyear)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@schoolyear = Schoolyear.find(params[:id])
			@schoolyear.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end



	def close
		if check_admin
			sy = Schoolyear.find(params[:id])
			sy.state = 'Cerrado'
			if sy.save
				redirect_to "/schoolyears"
				return
			else
				flash[:error] = "No se pudo cerrar el ciclo escolar."
			end
		else
			flash[:error] = "Acceso restringido."
		end
	end

	def activate
		if check_admin
			sy = Schoolyear.find(params[:id])
			sy.state = 'Activo'
			if sy.save
				redirect_to "/schoolyears"
				return
			else
				flash[:error] = "No se pudo marcar al ciclo escolar comoactivo."
			end
		else
			flash[:error] = "Acceso restringido."
		end
	end

	def inscription
		if check_admin
			sy = Schoolyear.find(params[:id])
			sy.state = 'Inscripciones'
			if sy.save
				redirect_to "/schoolyears"
				return
			else
				flash[:error] = "No se pudo abrir el ciclo escolar para inscripciones."
			end
		else
			flash[:error] = "Acceso restringido."
		end
	end



	# This method received an id (i), and a state (st) and checks that after saving there
	# won't be more than one 'Activo' schoolyear, there won't be more than one 'Inscripciones'
	# schoolyear.
	# Returns false if there is/will be a conflict,
	# 		  true  otherwise.
	def noConflictStates(i, st)
		if st != 'Cerrado'
			sy = Schoolyear.where(state: st).all
			if sy.length == 1 and sy[0].id != i
				false
			elsif sy.length > 1
				false
			end
		end

		true
	end

end