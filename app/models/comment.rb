class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable

  validates :author, presence: true
  validates :commentable, presence: true
  validates :content, presence: true, length: { maximum: 500 }
end
