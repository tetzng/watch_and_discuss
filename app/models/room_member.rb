# frozen_string_literal: true

class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :member, class_name: 'User'

  validate :periods_must_not_overlap

  private

  def periods_must_not_overlap
    if member.joined_rooms
         &.where('end_time > ? and ? > start_time', room.start_time, room.end_time)
             .present?
      errors[:base] << '既に参加している部屋と期間が重複しています'
    end
  end
end
