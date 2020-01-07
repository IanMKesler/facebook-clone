class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy


  validates :author, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
