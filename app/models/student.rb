#encoding: utf-8

class Student < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :charges
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :classis
  has_many :discharges
  has_many :works
  has_many :payments

  accepts_nested_attributes_for :person

  attr_accessible :person, :sExposition, :sInscription, :sMaterial, :sTuition, :sType, :school, :person_id, :person_attributes

  validates_inclusion_of :sType, in: %w( Hermanos Economica NA )
  validates :person_id, :presence => true, :uniqueness => true, :unless => "! person.nil?"
  validates_associated :person

  before_save :paymentsRule

  def paymentsRule
    if self.sType == 'NA'
      self.sExposition = 0
      self.sInscription = 0
      self.sMaterial = 0
      self.sTuition = 0
    end
  end

  def name
    return self.person.name
  end

  def dischargedInSchoolyear(schoolyear)
    for d in self.discharges
      if schoolyear.dateInSchoolyear(d.dateof)
        return true
      end
    end
    
    return false
  end

  def dischargedBy(cutoffDate)
    for d in self.discharges
      if cutoffDate > d.dateof
        return true
      end
    end

    return false
  end

end
