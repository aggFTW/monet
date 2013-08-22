class AddStdcostsToSchoolyears < ActiveRecord::Migration
  def change
    add_column :schoolyears, :stdInscription, :float
    add_column :schoolyears, :stdMaterial, :float
    add_column :schoolyears, :stdExposition, :float
  end
end
