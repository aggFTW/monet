class AddNextToSchoolyears < ActiveRecord::Migration
  def change
    add_column :schoolyears, :next, :boolean
  end
end
