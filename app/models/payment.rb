#encoding: utf-8

class Payment < ActiveRecord::Base
  belongs_to :student
  belongs_to :charge
  
  attr_accessible :amount, :charge, :comment, :dateof, :student

  validates :dateof, :presence => true
  validates :amount, :numericality => { :greater_than_or_equal_to => 0 }
  validates :student, :presence => true
  validates :charge, :presence => true
end
