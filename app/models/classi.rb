#encoding: utf-8

class Classi < ActiveRecord::Base
  has_many :eassistances
  has_many :employees, through: :eassistances
  has_one :group
  has_and_belongs_to_many :students

  attr_accessible :dateof, :group, :timeof
end
