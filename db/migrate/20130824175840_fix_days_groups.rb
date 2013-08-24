class FixDaysGroups < ActiveRecord::Migration
  def change
  	remove_column :groups, :days
  	add_column :groups, :mo, :boolean
  	add_column :groups, :tu, :boolean
  	add_column :groups, :we, :boolean
  	add_column :groups, :th, :boolean
  	add_column :groups, :fr, :boolean
  	add_column :groups, :sa, :boolean
  	add_column :groups, :su, :boolean
  end
end
