#encoding: utf-8
class ChargesController < ApplicationController
	def index
		if check_admin
			@charges = Charge.all
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def new
		if check_admin
			@charge = Charge.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def newgroups
		if check_admin
			@charge = Charge.new
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def create
		if check_admin

			@charge = Charge.new(params[:charge])

			if @charge.students.length == 1
				if @charge.ctype == "Inscripcion"
					@charge.amount = @charge.students.first.sInscription
				elsif @charge.ctype == "Colegiatura"
					@charge.amount = @charge.students.first.sTuition
				elsif @charge.ctype == "Exposicion"
					@charge.amount = @charge.students.first.sExposition
				elsif @charge.ctype == "Material"
					@charge.amount = @charge.students.first.sMaterial
				end
			end
		
			if @charge.save
				if ! params[:group_ids].nil?
					groups = params[:group_ids]

					groups.each do |group_id|
						Group.find(group_id).activeStudents.each do |student|
							if student.sInscription != 0 && @charge.ctype == "Inscripcion"
								@newCharge = Charge.new(params[:charge])
								@newCharge.amount = student.sInscription
								@newCharge.students += student
								@newCharge.save
							elsif student.sTuition != 0 && @charge.ctype == "Colegiatura"
								@newCharge = Charge.new(params[:charge])
								@newCharge.amount = student.sTuition
								@newCharge.students += student
								@newCharge.save
							elsif student.sExposition != 0 && @charge.ctype == "Exposicion"
								@newCharge = Charge.new(params[:charge])
								@newCharge.amount = student.sExposition
								@newCharge.students += student
								@newCharge.save
							elsif student.sMaterial != 0 && @charge.ctype == "Material"
								@newCharge = Charge.new(params[:charge])
								@newCharge.amount = student.sMaterial
								@newCharge.students += student
								@newCharge.save
							else
								@charge.students += [student]
							end
						end
					end
				end

				flash[:notice] = "Se ha creado un nuevo cargo."
			else
				flash[:error] = "Sus datos no son válidos."
			end

			redirect_to(charges_path)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end


	def show
		if check_admin
			@charge = Charge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def edit
		if check_admin
			@charge = Charge.find(params[:id])
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def update
		if check_admin
			@charge = Charge.find(params[:id])
		 
			if @charge.update_attributes(params[:charge])
				flash[:notice] = 'Los datos del cargo fueron actualizados correctamente.'
		    else
		    	flash[:error] = "No se pudieron actualizar los datos del cargo."
		    end

		    redirect_to(@charge)
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end

	def destroy
		if check_admin
			@charge = Charge.find(params[:id])
			@charge.destroy

			redirect_to :action => 'index'
		else
			flash[:error] = "Acceso restringido."
			redirect_to(root_path)
		end
	end
end
