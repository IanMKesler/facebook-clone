class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.belongs_to :author, class_name: "User"
      t.text :content

      t.timestamps
    end
  end
end
