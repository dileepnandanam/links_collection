class Visitor < ApplicationRecord
  has_many :queries
  has_many :contributions
end
