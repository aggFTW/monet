#encoding: utf-8

class Person < ActiveRecord::Base
  has_one :address
  has_one :dad, :class_name => "Person", :foreign_key => 'dad_id'
  has_one :mom, :class_name => "Person", :foreign_key => 'mom_id'
  has_many :siblingrelations
  has_many :siblings, :class_name => "Person"

  attr_accessible :address, :cellr, :dob, :email, :fname, :lname, :dad, :mom, :sex

  before_save :normalizeAttributes

  def normalizeAttributes
    f = ""
    for t in self.fname.split(' ')
      f += t.capitalize + ' '
    end
    self.fname = f.lstrip

    l = ""
    for t in self.lname.split(' ')
      l += t.capitalize + ' '
    end

    self.lname = l.lstrip
  end
end
