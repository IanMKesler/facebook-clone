class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :friend_requests, foreign_key: "invitee_id"

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true, length: { maximum: 250 }
  validates :last_name, presence:true, length: { maximum: 250 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }

  def full_name
    self.first_name + " " + self.last_name
  end
end
