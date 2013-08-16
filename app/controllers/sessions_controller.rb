#encoding: utf-8
class SessionsController < ApplicationController

  # before_filter :authenticate_user, :only => [:home, :profile, :setting]
  # before_filter :save_login_state, :only => [:login]

  def login
  	authorized_user = User.find_by_username(params[:gusername].downcase)

  	if authorized_user && authorized_user.authenticate(params[:gpassword])
  		session[:user_id] = authorized_user.id
  		flash[:notice] = "Bienvenido #{authorized_user.person.fname} #{authorized_user.person.lname}."
  		redirect_to(root_path)
  	else
  		flash[:error] = "Usuario o password inválidos."
  		redirect_to('/signup')
  	end
  end

  def logout
  	session[:user_id] = nil
  	redirect_to('/signup')
  end

end
