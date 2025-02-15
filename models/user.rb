require 'uuidtools'

class User < ApplicationRecord
  has_secure_password

  has_many :resource_records

  validates :login, :presence => true, :uniqueness => { :case_sensitive => false }
end