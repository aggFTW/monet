#encoding: utf-8
class UsersController < ApplicationController

	before_filter :authenticate_user, :only => [:index, :show, :edit, :update, :destroy, :change_admin, :change_student]

	def index
		if check_admin
			@users = User.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		@user = User.new
	end

	def signup
		if session[:user_id].nil?
			@user = User.new
		else
			user = User.find session[:user_id]
			redirect_to(user)
		end
	end

	def create
		@user = User.new(params[:user])
		@user.utype = 0
		
		if @user.save
			flash[:notice] = "Usuario creado de manera exitosa. Haga Sign In."
		else
			flash[:error] = "Sus datos no son válidos."
		end

		redirect_to("/signup")
	end


	def show
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin || @current_user.id.to_s == params[:id]
			@user = User.find(params[:id])
		 
			if @user.update_attributes(params[:user])
				flash[:notice] = 'El usuario fue actualizado de manera correcta.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del usuario."
		    end

		    redirect_to(@user)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@user = User.find(params[:id])
			@user.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	



	def get_current_user
		respond_to do |format|
			format.json { render json: session[:user_id].to_json }
		end
	end

	def change_student
		if check_admin
			user = User.find(params[:id])
			user.utype = 0
			if user.save
				redirect_to "/users"
				return
			else
				flash[:error] = "No se pudo hacer alumno al usuario."
			end
		else
			flash[:error] = "Necesita ser administrador para modificar el tipo de un usuario."
		end
	end

	def change_admin
		if check_admin
			user = User.find(params[:id])
			user.utype = 1
			if user.save
				redirect_to "/users"
				return
			else
				flash[:error] = "No se pudo hacer administrador al usuario."
			end
		else
			flash[:error] = "Necesita ser administrador para modificar el tipo de un usuario."
		end
	end

end