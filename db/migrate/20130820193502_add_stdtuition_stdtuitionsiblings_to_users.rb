class AddStdtuitionStdtuitionsiblingsToUsers < ActiveRecord::Migration
  def change
    add_column :schoolyears, :stdTuition, :float
    add_column :schoolyears, :stdTuitionSiblings, :float
  end
end
