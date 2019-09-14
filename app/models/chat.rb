class Chat < ApplicationRecord
  validates :text, presence: true
end
