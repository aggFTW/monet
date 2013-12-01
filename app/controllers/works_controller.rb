#encoding: utf-8
class WorksController < ApplicationController

	def index
		if check_admin
			@works = Work.order('student_id ASC, schoolyear_id DESC')
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def indexActiveSchoolyear
		if check_admin
			schoolyear = Schoolyear.where("state = ?", "Activo").all

			if schoolyear.length == 1
				schoolyear = schoolyear.first
				@works = schoolyear.groups.map { |g| g.students }.flatten.map { |s| s.works }.flatten.uniq
			else
				redirect_to controller: :reports, action: :error, :message => "No hay sólo 1 ciclo escolar activo. Cierre los ciclos escolares pasados para poder accesar a las obras del ciclo escolar."
			end
			
			Work.order('student_id ASC, schoolyear_id DESC')
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@work = Work.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@work = Work.new(params[:work])
		
			if @work.save
				flash[:notice] = "Se ha creado una nueva obra."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(works_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@work = Work.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@work = Work.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@work = Work.find(params[:id])
		 
			if @work.update_attributes(params[:work])
				flash[:notice] = 'Los datos de la obra fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos de la obra."
		    end

		    redirect_to(@work)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@work = Work.find(params[:id])
			@work.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

end
