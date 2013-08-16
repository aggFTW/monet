class FixColumnNameCycle < ActiveRecord::Migration
  def change
    rename_column :works, :cycle_id, :schoolyear_id
  end
end
