#encoding: utf-8
class GroupsController < ApplicationController

	def index
		if check_admin
			@groups = Group.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@group = Group.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@group = Group.new(params[:group])
		
			if @group.save
				flash[:notice] = "Se ha creado un nuevo gasto."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(groups_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@group = Group.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@group = Group.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@group = Group.find(params[:id])
		 
			if @group.update_attributes(params[:group])
				flash[:notice] = 'Los datos del gasto fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del gasto."
		    end

		    redirect_to(@group)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@group = Group.find(params[:id])
			@group.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
	
end
