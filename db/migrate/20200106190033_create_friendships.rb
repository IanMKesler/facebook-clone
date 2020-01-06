class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.belongs_to :requester, class_name: "User"
      t.belongs_to :requestee, class_name: "User"
      t.timestamps
    end
  end
end
