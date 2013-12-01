#encoding: utf-8

class Schoolyear < ActiveRecord::Base
  has_many :groups
  has_many :works
  
  attr_accessible :beginning, :end, :name, :stdTuition, :stdTuitionSiblings, :state, :stdInscription, :stdMaterial, :stdExposition

  validates :name, :presence => true
  validates :beginning, :presence => true
  validates :end, :presence => true
  validates_inclusion_of :state, in: %w( Activo Cerrado Inscripciones ), :presence => true
  validates :stdTuition, :presence => true
  validates :stdTuitionSiblings, :presence => true
  validates :stdInscription, :presence => true
  validates :stdMaterial, :presence => true
  validates :stdExposition, :presence => true

  before_save :checkDates

  def checkDates
    if self.beginning <= self.end
      true
    else
      false
    end
  end

  def dateInSchoolyear(eventDate)
    return eventDate <= self.end && eventDate >= self.beginning
  end

  def yearForMonth(month)
    if month <= 8
      return self.end.year
    else
      return self.beginning.year
    end
  end

end
