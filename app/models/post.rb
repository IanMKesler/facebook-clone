class Post < ApplicationRecord
  belongs_to :author, class_name: "User"

  validates :author, presence: true
  validates :content, presence: true, length: { maximum: 1000 }
end
