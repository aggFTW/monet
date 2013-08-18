#encoding: utf-8

class Address < ActiveRecord::Base
  has_many :people
  
  attr_accessible :interior, :neighborhood, :number, :street, :zip

  validates :interior, :numericality => { :only_integer => true }
  validates :number, :presence => true,
  					 :numericality => { :only_integer => true }
  validates :street, :presence => true
  validates_uniqueness_of :number, :scope => [:street, :zip]

  def to_s
  	s = ''
  	s += self.street + ' ' + self.number
  	unless self.interior.nil?
  		s += ', interior ' + self.interior
  	end
  	s += '. ' + self.neighborhood + ', ' + self.zip + '.'

  	return s
  end
end
