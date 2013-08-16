#encoding: utf-8

class Charge < ActiveRecord::Base
  has_and_belongs_to_many :students

  attr_accessible :amount, :ctype, :datedue, :name
end
