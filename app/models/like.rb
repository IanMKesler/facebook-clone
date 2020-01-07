class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  validate :unique, :non_authored
  validates :likeable, presence: true

  def unique
    begin
      if Like.where(user_id: user_id, likeable_id: likeable_id,
                     likeable_type: likeable_type).exists?
        errors.add(:likeable_id, 'Can only like once')
      end
    rescue
    end
  end

  def non_authored
    begin
      if self.likeable.author_id == user_id
        errors.add(:likeable_id, 'Cannot like self authored')
      end
    rescue
    end 
  end
end
