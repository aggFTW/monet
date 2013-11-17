#encoding: utf-8
class PaymentsController < ApplicationController

	def index
		if check_admin
			@payments = Payment.order('dateof DESC')
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@charges = []
			@payment = Payment.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin
			@payment = Payment.new(params[:payment])
			@payment.student = Student.find(params[:student_id])
			@payment.charge = Charge.find(params[:charge_id])
		
			if @payment.save!
				flash[:notice] = "Se ha registrado el pago."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(payments_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def show
		if check_admin
			@payment = Payment.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@payment = Payment.find(params[:id])
			@charges = @payment.student.charges
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@payment = Payment.find(params[:id])
			@charges = Charge.all
		 
			if @payment.update_attributes(params[:payment])
				flash[:notice] = 'Los datos del pago fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del pago."
		    end

		    redirect_to(@payment)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@payment = Payment.find(params[:id])
			@payment.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
