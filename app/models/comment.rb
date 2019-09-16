class Comment < ApplicationRecord
  belongs_to :post, optional: true
  def under
    kind == 'videoresponse' ? Link.find(post_id) : post
  end
  belongs_to :user
  has_many :votes
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: :parent_id
  validates :text, presence: true
  before_destroy :cancel_notifications

  scope :for_post, -> { where(kind: 'postresponse') }
  scope :for_video, -> { where(kind: 'videoresponse') }
  
  def cancel_notifications
    Notification.where(target_id: id, target_type: 'Comment').delete_all
  end

  after_create :notify_connections
  
  def notify_connections
    Connection.where(to_user_id: user_id).map(&:user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end

    Connection.where(user_id: user_id).map(&:to_user).each do |user|
      Notifier.perform_now_or_later user, 'create', self
    end

    Notifier.perform_now_or_later under.user, 'create', self if kind == 'postresponse'

    (post.comments.map(&:user) - [parent.try(:user)]).each do |commenter|
       Notifier.perform_now_or_later user, 'create', self unless commenter != self.user
    end

    if parent
      Notifier.perform_now_or_later parent.user, 'reply', self unless parent.user != user
    end
  end

  def children
    Comment.where(parent_id: id)
  end

  def upvote_count
    votes.where(weight: 1).count
  end

  def downvote_count
    votes.where(weight: -1).count
  end
end
