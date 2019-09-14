class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :to_user, class_name: 'User'
end
