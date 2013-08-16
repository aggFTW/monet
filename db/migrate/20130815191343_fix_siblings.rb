class FixSiblings < ActiveRecord::Migration
  def change
  	rename_table :people_people, :siblings
  	add_column :siblings, :sibling_id, :integer
  end
end
