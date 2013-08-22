#encoding: utf-8
class SessionsController < ApplicationController




  def login
    unless params[:gusername].nil? or params[:gpassword].nil?
    	authorized_user = User.find_by_username(params[:gusername].downcase)

    	if authorized_user && authorized_user.authenticate(params[:gpassword])
    		session[:user_id] = authorized_user.id
    		flash[:notice] = "Bienvenido #{authorized_user.person.fname} #{authorized_user.person.lname}."
    		redirect_to(root_path)
    	else
    		flash[:error] = "Usuario o password inválidos."
    		redirect_to(root_path)
    	end
    end
  end




  def logout
  	session[:user_id] = nil
  	redirect_to(root_path)
  end





end
