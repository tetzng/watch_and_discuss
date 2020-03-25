# frozen_string_literal: true

class Message < ApplicationRecord
  has_one :like
  belongs_to :room
  belongs_to :user

  validates :body, presence: true

  validate :cannot_be_created_in_ended_room

  private

  def cannot_be_created_in_ended_room
    return if room.end_time > Time.zone.now

    errors[:base] << '終了時刻を過ぎたため作成できません'
  end
end
