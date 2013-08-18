#encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :charges
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :classis
  has_many :discharges
  has_many :works
  has_many :payments

  attr_accessible :person, :sExposition, :sInscription, :sMaterial, :sTuition, :sType, :school

  validates :sInscription, :presence => true
  validates :sMaterial, :presence => true
  validates :sExposition, :presence => true
  validates :sTuition, :presence => true
  validates_inclusion_of :sType, in: %w( Hermanos Economica ), :presence => true
  validates :person, :presence => true, :uniqueness => true

end
