class Notification < ApplicationRecord
  belongs_to :user
  scope :unseen, -> {where seen: false}

  belongs_to :target, polymorphic: true, optional: true

  Translations = {
    user_create: 'Welcome {user}, Your 4 Digit PIN is {pin}, Keep it Out of Reach of Children',
    post_create: '{user} posted {url}{group}',
    comment_create: '{user} {url} on {post}',
    comment_reply: '{user} replied to comment on {post}',
    vote_create: '{user} {type}ed {url}',
    questions_update: '{url} Updated',
    connection_create: '{user1} Connected to {user2}',
    connection_create_personal: '{user1} and You are Now Connected',
    response_create: '{user} send You a Request, {url}'
  }.with_indifferent_access

  def generate_msg(obj, action, binds)
    trans = Translations["#{obj.class.name}_#{action}".underscore]
    binds.each{|key, val| trans.gsub!("{#{key}}", val.to_s)}
    trans
  end
end
