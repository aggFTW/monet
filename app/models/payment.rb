#encoding: utf-8

class Payment < ActiveRecord::Base
  has_one :student
  has_one :charge
  
  attr_accessible :amount, :charge, :comment, :dateof, :ptype, :student
end
