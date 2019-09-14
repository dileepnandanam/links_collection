class Connection < ApplicationRecord
  belongs_to :user
  belongs_to :to_user, class_name: 'User'

  after_create :notify_connections

  def notify_connections
    # notify my friends and friends of newly connected friends

    reciver_ids = Connection.where(to_user_id: to_user_id).map(&:user_id) - [user_id]
    User.where(id: reciver_ids).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end
    binding.pry
    Notifier.perform_now_or_later user, 'create_personal', self
  end
end
