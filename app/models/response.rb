class Response < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers
  belongs_to :user, optional: true
  belongs_to :responce_user, class_name: 'User'
  belongs_to :group, optional: true

  after_create :notify

  def notify
    Notifier.perform_now_or_later responce_user, 'create', self
  end
end
