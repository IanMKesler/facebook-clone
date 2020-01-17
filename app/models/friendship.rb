class Friendship < ApplicationRecord
  belongs_to :requester, class_name: "User" 
  belongs_to :requestee, class_name: "User" 


  validate :request
  validates :requester, presence: true
  validates :requestee, presence: true

  after_create :destroy_request

  def request
    begin
      unless FriendRequest.where(inviter_id: requestee_id, invitee_id: requester_id).exists?
        errors.add(:requestee_id, 'No matching friend request')
      end
    rescue
    end
  end

  def destroy_request
    FriendRequest.where(inviter_id: requestee_id, invitee_id: requester_id).first.destroy
  end
end
