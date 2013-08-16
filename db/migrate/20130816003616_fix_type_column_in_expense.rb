class FixTypeColumnInExpense < ActiveRecord::Migration
  def change
  	rename_column :expenses, :type, :etype
  end
end
