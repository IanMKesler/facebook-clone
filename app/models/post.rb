class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :likes, as: :likeable
  has_many :comments, as: :commentable


  validates :author, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
