#encoding: utf-8

class Charge < ActiveRecord::Base
  has_and_belongs_to_many :students

  attr_accessible :amount, :ctype, :datedue, :name

  validates :amount, :numericality => { :greater_than_or_equal_to => 0 }
  validates_inclusion_of :ctype, in: %w( Renta Servicios Material Sueldos ), :presence => true
  validates :datedue, :presence => true
  validates :name, :presence => true
end
