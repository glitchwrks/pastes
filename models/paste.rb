class Paste < ApplicationRecord

  belongs_to :user

  validates :name, :presence => true, :uniqueness => { :case_sensitive => true }
  validates :content, :presence => true

end