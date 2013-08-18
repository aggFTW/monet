class DeleteTypePayments < ActiveRecord::Migration
  def change
  	remove_column :payments, :ptype
  end
end
