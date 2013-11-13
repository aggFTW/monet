class Removesiblingsfromdb < ActiveRecord::Migration
  def change
  	drop_table :siblingrelations
  end
end
