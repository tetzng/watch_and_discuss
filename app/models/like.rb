class Like < ApplicationRecord
  belongs_to :message
  belongs_to :user

  validate :cannot_be_created_except_owner

  private

  def cannot_be_created_except_owner
    return if message.room.owner_id == user_id

    errors[:base] << '部屋の管理者以外はいいねを登録できません'
  end
end
