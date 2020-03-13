# frozen_string_literal: true

class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :member, class_name: 'User'

  validate :periods_must_not_overlap
  validate :cannot_be_joined_after_end_time
  validate :cannot_be_joined_exceed_the_capacity

  private

  def periods_must_not_overlap
    if member.joined_rooms
         &.where('end_time > ? and ? > start_time', room.start_time, room.end_time)
             .present?
      errors[:base] << '既に参加している部屋と期間が重複しています'
    end
  end

  def cannot_be_joined_after_end_time
    return if room.end_time > Time.zone.now

    errors[:base] << '終了した部屋には参加できません'
  end

  def cannot_be_joined_exceed_the_capacity
    return if room.all_members_size < 5

    errors[:base] << '人数制限に達した部屋には参加できません'
  end
end
