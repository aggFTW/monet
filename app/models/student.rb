#encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :charges
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :classis
  has_many :discharges
  has_many :works
  has_many :payments

  attr_accessible :person, :sExposition, :sInscription, :sMaterial, :sTuition, :sType, :school, :person_id

  validates_inclusion_of :sType, in: %w( Hermanos Economica NA )
  validates :person_id, :presence => true, :uniqueness => true

  before_save :payments

  def payments
    if self.sType == 'NA'
      self.sExposition = 0
      self.sInscription = 0
      self.sMaterial = 0
      self.sTuition = 0
    end
  end

  def personName
    return self.person.name
  end

end
