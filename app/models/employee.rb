#encoding: utf-8

class Employee < ActiveRecord::Base
  has_many :eassistances
  has_many :classis, through: :eassistances
  belongs_to :person
  has_and_belongs_to_many :groups
  has_many :expenses

  attr_accessible :person, :role, :salary
end
