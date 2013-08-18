#encoding: utf-8

class Schoolyear < ActiveRecord::Base
  has_many :schoolyears
  has_many :works
  
  attr_accessible :active, :beginning, :end, :name

  validates :name, :presence => true
  validates :beginning, :presence => true
  validates :end, :presence => true
  validates :active, :presence => true
end
