class FixStateSchoolyears < ActiveRecord::Migration
  def change
  	remove_column :schoolyears, :active
  	remove_column :schoolyears, :next
  	add_column :schoolyears, :state, :string
  end
end
