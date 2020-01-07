class FriendRequest < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"

  
  validate :non_duplicate
  validate :not_friends
  validates :inviter, presence: true
  validates :invitee, presence: true
  

  def non_duplicate
    if FriendRequest.where(inviter_id: inviter_id, invitee_id: invitee_id).exists? || FriendRequest.where(inviter_id: invitee_id, invitee_id: inviter_id).exists?
      errors.add(:invitee_id, "Duplicate request")
    end
  end

  def not_friends
    begin
      if User.find(self.inviter_id).friends.include?(User.find(self.invitee_id))
        errors.add(:invitee_id, "Already friends")
      end
    rescue
    end
  end
end
