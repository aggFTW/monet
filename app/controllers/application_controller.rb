#encoding: utf-8
class ApplicationController < ActionController::Base

  helper_method :check_admin
  helper_method :check_student

  protect_from_forgery

  protected 
	
	def authenticate_user
		unless session[:user_id]
			# flash[:error] = "Necesita una sesión de usuario válida para esta operación. Por favor inicie sesión."
			redirect_to('/login')
			return false
		else
			# set current user object to @current_user object variable
			@current_user = User.find session[:user_id] 
			return true
		end
	end

	def save_login_state
		if session[:user_id]
			redirect_to(root_path)
			return false
		else
			return true
		end
	end

	def check_admin
		if session[:user_id]
			# set current user object to @current_user object variable
			@current_user = User.find session[:user_id]
			if @current_user && @current_user.utype == 1 #Admin
				return true
			end
		end

		return false
	end

	def check_student
		if session[:user_id]
			# set current user object to @current_user object variable
			@current_user = User.find session[:user_id]
			if @current_user && @current_user.utype >= 0 #Student
				return true
			end
		end

		return false
	end

	def reset_env_vars
		session[:address_id] = nil
		session[:dad_id] = nil
		session[:mom_id] = nil
		session[:employee_person_id]
	end

	def toDate(year, month)
		Date.strptime("{ %d, %d, %d }" % [year, month, 1], "{ %Y, %m, %d }")
	end

	def toDateLastDay(year, month)
		Date.civil(year, month, -1)
	end

	def normalizeYear(date)
		return Date.strptime("{ %d, %d, %d }" % [2000, date.month, date.day], "{ %Y, %m, %d }")
	end

end
