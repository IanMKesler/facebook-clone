class Friendship < ApplicationRecord
  belongs_to :requester, class_name: "User" 
  belongs_to :requestee, class_name: "User" 

  validates :requester_id, presence: true
  validates :requestee_id, presence: true
end
