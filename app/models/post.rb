class Post < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :likes, as: :likeable

  validates :author, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
