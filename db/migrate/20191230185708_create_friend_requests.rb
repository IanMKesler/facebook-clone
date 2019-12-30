class CreateFriendRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :friend_requests do |t|
      t.belongs_to :inviter, class_name: "User"
      t.belongs_to :invitee, class_name: "User"

      t.timestamps
    end
  end
end
