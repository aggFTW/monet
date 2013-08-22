#encoding: utf-8
class ExpensesController < ApplicationController

	def index
		if check_admin
			@expenses = Expense.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@expense = Expense.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@expense = Expense.new(params[:expense])
		
			if @expense.save
				flash[:notice] = "Se ha creado un nuevo gasto."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(expenses_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@expense = Expense.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@expense = Expense.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@expense = Expense.find(params[:id])
		 
			if @expense.update_attributes(params[:expense])
				flash[:notice] = 'Los datos del gasto fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del gasto."
		    end

		    redirect_to(@expense)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@expense = Expense.find(params[:id])
			@expense.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

end
