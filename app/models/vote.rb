class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  after_create :notify

  def notify
    Notifier.perform_now_or_later (comment || post).user, 'create', self
  end
end
