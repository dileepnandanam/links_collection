class Feed
  attr_accessor :user
  def initialize(user)
    @user = user
  end

  def get()
    if user.present?
      Post.joins(%{
        inner join connections on connections.to_user_id = posts.user_id
      }).where('posts.id > coalesce(connections.last_seen_post_id, 0) and connections.user_id = ?', user.id).order('posts.created_at DESC')
    else
      Post.all
    end
  end

  def mark_seen_untle(post)
    user.connection.where(to_user_id: post.user_id).first.update(last_seen_post_id: post.id)
  end
end