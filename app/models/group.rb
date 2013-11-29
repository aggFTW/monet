#encoding: utf-8

class Group < ActiveRecord::Base
  belongs_to :schoolyear
  has_and_belongs_to_many :employees
  has_and_belongs_to_many :students
  has_many :classis

  attr_accessible :name, :schedule, :schoolyear, :schoolyear_id, :mo, :tu, :we, :th, :fr, :sa, :su, :student_ids, :employee_ids, :classi_ids

  validates :name, :presence => true
  validates :schedule, :presence => true
  validates :schoolyear, :presence => true
  validates_inclusion_of :mo, :in => [true, false]
  validates_inclusion_of :tu, :in => [true, false]
  validates_inclusion_of :we, :in => [true, false]
  validates_inclusion_of :th, :in => [true, false]
  validates_inclusion_of :fr, :in => [true, false]
  validates_inclusion_of :sa, :in => [true, false]
  validates_inclusion_of :su, :in => [true, false]

  def daysString
    first = false
    d = ''

    first, d = dayS(self.mo, d, 'Lunes', first)
    first, d = dayS(self.tu, d, 'Martes', first)
    first, d = dayS(self.we, d, 'Miércoles', first)
    first, d = dayS(self.th, d, 'Jueves', first)
    first, d = dayS(self.fr, d, 'Viernes', first)
    first, d = dayS(self.sa, d, 'Sábado', first)
    first, d = dayS(self.su, d, 'Domingo', first)

    d
  end

  def dayS(boolV, d, day, first)
    if boolV
      if first
        d += ', '
      end
      first = true
      d += day
    end

    return first, d
  end

  def activeStudents
    allStudents = self.students
    return allStudents.keep_if { |s| not s.dischargedInSchoolyear(self.schoolyear) }
  end

  # TODO: What if the student is discharged, admitted later, discharged? It's a mess
  # Just introduce a freaking admission date already :(
  def activeStudentsInMonth(month)
    allStudents = self.students
    return allStudents.keep_if { |s| not s.dischargedBy(
      toDateLastDay(self.schoolyear.yearForMonth(month), month)) }
  end

  def toDateLastDay(year, month)
    Date.civil(year, month, -1)
  end

end
