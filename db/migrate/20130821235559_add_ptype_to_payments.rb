class AddPtypeToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :ptype, :string
  end
end
