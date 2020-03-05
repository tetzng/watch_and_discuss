# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_members
  has_many :members, through: :room_members
  belongs_to :owner, class_name: 'User'

  scope :unstarted, -> { where('start_time > ?', Time.zone.now) }
  scope :ended, -> { where('end_time < ?', Time.zone.now) }

  def all_members_size
    members.size + 1
  end
end
