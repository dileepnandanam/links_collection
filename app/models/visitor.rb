class Visitor < ApplicationRecord
  has_many :queries
  has_many :contributions
  has_many :links
  has_many :comments
end
