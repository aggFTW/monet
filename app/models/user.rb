#encoding: utf-8

class User < ActiveRecord::Base
  belongs_to :person

  has_secure_password
  attr_accessible :password, :username, :password_confirmation, :person

  validates :username,	:presence => true, :uniqueness => true
  validates :utype,	:presence => true,
          					:numericality => { 	:only_integer => true,
          										:less_than => 2,
          										:greater_than_or_equal_to => 0 }
  validates_presence_of :password,	:on => :create
  validate :person, :presence => true, :uniqueness => true

  before_save :normalizeAttributes

  def normalizeAttributes
    self.username = self.username.downcase
  end
end
