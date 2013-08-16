#encoding: utf-8

class Expense < ActiveRecord::Base
  belongs_to :employee
  
  attr_accessible :amount, :dateof, :description, :employee, :type
end
