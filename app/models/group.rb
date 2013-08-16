#encoding: utf-8

class Group < ActiveRecord::Base
  has_one :schoolyear
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :students
  has_many :classis

  attr_accessible :days, :name, :schedule, :schoolyear
end
