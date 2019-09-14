class Question < ApplicationRecord
  validates :text, presence: true
  default_scope { order('sequence ASC') }
  belongs_to :user, optional: true
end
