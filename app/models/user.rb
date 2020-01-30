class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :recieved_requests, class_name: "FriendRequest", foreign_key: "invitee_id", dependent: :destroy
  has_many :sent_requests, class_name: "FriendRequest", foreign_key: "inviter_id", dependent: :destroy
  has_many :requester_friendships, class_name: "Friendship", foreign_key: :requester_id, dependent: :destroy
  has_many :requester_friends, through: :requester_friendships, source: :requestee
  has_many :requestee_friendships, class_name: "Friendship", foreign_key: :requestee_id, dependent: :destroy
  has_many :requestee_friends, through: :requestee_friendships, source: :requester
  has_many :posts, foreign_key: :author, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_many :comments, foreign_key: :author, dependent: :destroy
  has_many :liked_comments, through: :likes, source: :likeable, source_type: 'Comment'
  has_attached_file :avatar, default_url: "avatar.jpeg",  styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }
  

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 250 }
  validates :last_name, presence:true, length: { maximum: 250 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/                  

  def full_name
    self.first_name + " " + self.last_name
  end

  def friends
    User.where(id: friend_ids)
  end

  def friendship(user)
    Friendship.where(requester_id: id, requestee_id: user.id).or(Friendship.where(requester_id: user.id, requestee_id: id)).first
  end

  def friendships
    Friendship.where(requester_id: id).or(Friendship.where(requestee_id: id))
  end

  def requests
    FriendRequest.where(inviter_id: id).or(FriendRequest.where(invitee_id: id))
  end

  def feed
    Post.where(author_id: id).or(Post.where(author_id: friend_ids)).order(created_at: :desc)
  end

  private
    def friend_ids
      friendships.map do |f|
        f.requester_id == self.id ? f.requestee_id : f.requester_id
      end
    end
end
