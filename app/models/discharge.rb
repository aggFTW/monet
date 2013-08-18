#encoding: utf-8

class Discharge < ActiveRecord::Base
  belongs_to :student

  attr_accessible :dateof, :reason, :student

  validates :dateof, :presence => true
  validates :student, :presence => true
end
