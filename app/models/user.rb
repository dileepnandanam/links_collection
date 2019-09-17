class User < ApplicationRecord
  attr_accessor :reset_password_token, :reset_password_sent_at, :password, :password_confirmation, :current_password
  has_many :connections
  has_many :questions
  has_many :responses
  has_many :posted_responses, foreign_key: :responce_user_id, class_name: 'Response'
  has_many :posted_posts, foreign_key: :post_user_id, class_name: 'Post'
  has_many :posts
  has_many :groups
  has_many :comments
  has_many :votes
  has_many :notifications

  validates :name, presence: true
  validates :gender, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
      user.gender = auth.info.gender
      user.link = auth.info.link
    end
  end

  after_create :set_pin
  def set_pin
    update(pin: rand.to_s[2..5])

    if Rails.env.production?
      Notifier.perform_now_or_later self, 'create', self
    end
  end

  def is_connected_to?(user)
    Connection.where(to_user_id: [id, user.id], user_id: [id: user.id]).count > 0
  end

  def has_unread_chats
    Chat.where(reciver_id: id, seen: false).count > 0
  end
end
