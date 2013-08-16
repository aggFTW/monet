#encoding: utf-8

class Schoolyear < ActiveRecord::Base
  has_many :schoolyears
  has_many :works
  
  attr_accessible :active, :beginning, :end, :name
end
