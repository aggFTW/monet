#encoding: utf-8

class Classi < ActiveRecord::Base
  has_many :eassistances, :dependent => :destroy
  has_many :employees, through: :eassistances
  belongs_to :group
  has_and_belongs_to_many :students

  accepts_nested_attributes_for :eassistances

  attr_accessible :dateof, :group, :timeof, :group_id, :employee_ids, :student_ids

  validates :dateof, :presence => true
  validates :group, :presence => true
  validates :timeof, :presence => true

  def listEmployees
  	e = ''
  	for em in self.employees
  		e += em.to_s + ', '
  	end
  	e = e[0..-3]
  	e
  end

  def listStudents
  	e = ''
  	for em in self.students
  		e += em.personName + ', '
  	end
  	e = e[0..-3]
  	e
  end
end
