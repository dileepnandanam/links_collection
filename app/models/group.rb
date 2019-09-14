class Group < ApplicationRecord
  has_many :questions
  belongs_to :user
  has_many :responses
  has_many :posts
end
