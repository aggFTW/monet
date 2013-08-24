#encoding: utf-8

class Eassistance < ActiveRecord::Base
  attr_accessible :payed

  belongs_to :classi
  belongs_to :employee

end
