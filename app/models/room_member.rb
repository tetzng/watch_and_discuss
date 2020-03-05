class RoomMember < ApplicationRecord
  belongs_to :room
  belongs_to :member, class_name: 'User'
end
