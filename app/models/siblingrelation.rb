#encoding: utf-8

class Siblingrelation < ActiveRecord::Base
  belongs_to :person
  belongs_to :sibling, :class_name => 'Person'
end