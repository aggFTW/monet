class FixSiblingsTableName < ActiveRecord::Migration
  def change
  	rename_table :siblings, :siblingrelations
  end
end
