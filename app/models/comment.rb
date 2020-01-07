class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  validates :author, presence: true
  validates :commentable, presence: true
  validates :content, presence: true, length: { maximum: 500 }
end
