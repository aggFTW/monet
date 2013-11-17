#encoding: utf-8

class Expense < ActiveRecord::Base
  belongs_to :employee
  
  attr_accessible :amount, :dateof, :description, :employee, :etype, :employee_id

  validates :amount, :presence => true,
  					 :numericality => { :greater_than => 0 }
  validates :description, :presence => true
  validates :dateof, :presence => true
  validates_inclusion_of :etype, in: %w( Renta Servicios Material Sueldos Impuestos Otro ), :presence => true
  validates :employee, :presence => true
end
