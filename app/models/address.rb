#encoding: utf-8

class Address < ActiveRecord::Base
  has_many :people
  
  attr_accessible :interior, :neighborhood, :number, :street, :zip
end
