class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :friend_requests, foreign_key: "invitee_id"
  has_many :requester_friendships, class_name: "Friendship", foreign_key: :requester_id
  has_many :requester_friends, through: :requester_friendships, source: :requestee
  has_many :requestee_friendships, class_name: "Friendship", foreign_key: :requestee_id
  has_many :requestee_friends, through: :requestee_friendships, source: :requester
  has_many :posts
  has_many :likes
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment'

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 250 }
  validates :last_name, presence:true, length: { maximum: 250 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  def full_name
    self.first_name + " " + self.last_name
  end

  def friends
    requester_friends + requestee_friends
  end
end
