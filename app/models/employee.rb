#encoding: utf-8

class Employee < ActiveRecord::Base
  has_many :eassistances
  has_many :classis, through: :eassistances
  belongs_to :person
  has_and_belongs_to_many :groups
  has_many :expenses

  attr_accessible :person, :role, :salary, :person_id

  validates :role, :presence => true
  validates :salary, :presence => true,
  					 :numericality => { :greater_than_or_equal_to => 0 }
  validates :person, :presence => true

  def to_s
    return self.person.name + ' (' + self.role + ')'
  end
end
