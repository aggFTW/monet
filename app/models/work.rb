#encoding: utf-8

class Work < ActiveRecord::Base
  belongs_to :schoolyear
  belongs_to :student
  
  attr_accessible :cycle, :student, :technique, :title
end
