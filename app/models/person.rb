#encoding: utf-8

class Person < ActiveRecord::Base
  belongs_to :address
  belongs_to :user
  belongs_to :dad, :class_name => "Person", :foreign_key => 'dad_id'
  belongs_to :mom, :class_name => "Person", :foreign_key => 'mom_id'

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
    self.fname + ' ' + self.lname
  end


  def self.withoutUser
    peopleWithUsers = User.all.map { |u| u.person.id }
    Person.where(Person.arel_table[:id].not_in(peopleWithUsers))
  end

  def age
    now = Date.today
    now.year - self.dob.year - ((now.month > self.dob.month || (now.month == self.dob.month && now.day >= self.dob.day)) ? 0 : 1)
  end

  def siblings
    fromMom = Person.where(:mom_id => self.mom.id)
    fromDad = Person.where(:dad_id => self.dad.id)

    siblingsArray = fromMom + fromDad

    return siblingsArray.uniq.remove(self)
  end

  def hasSiblings
    if Person.where(:mom_id => self.mom.id).length > 1
      return true
    end

    if Person.where(:dad_id => self.dad.id).length > 1
      return true      
    end

    return false
  end

end
