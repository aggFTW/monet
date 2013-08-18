#encoding: utf-8

class Person < ActiveRecord::Base
  belongs_to :address
  belongs_to :user
  belongs_to :dad, :class_name => "Person", :foreign_key => 'dad_id'
  belongs_to :mom, :class_name => "Person", :foreign_key => 'mom_id'
  has_many :siblingrelations
  has_many :siblings, :through => :siblingrelations, :class_name => "Person"

  attr_accessible :address, :cellr, :dob, :email, :fname, :lname, :dad, :mom, :sex, :user, :dad_id, :mom_id, :address_id

  validates :fname, :presence => true
  validates :lname, :presence => true
  validates :dob, :presence => true
  validates_inclusion_of :sex, in: %w( f m ), :presence => true

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

  def name
    s = self.fname + ' ' + self.lname
    return s
  end
end
