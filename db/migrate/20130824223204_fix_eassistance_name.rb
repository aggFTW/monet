class FixEassistanceName < ActiveRecord::Migration
  def change
    rename_table :eassistance, :eassistances
  end
end
