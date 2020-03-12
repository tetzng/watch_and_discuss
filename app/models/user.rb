# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :own_rooms, class_name: 'Room', foreign_key: :owner_id
  has_many :room_members, foreign_key: :member_id
  has_many :rooms, through: :room_members

  def joined_rooms
    joined_room_ids = own_room_ids + room_ids
    Room.where(id: joined_room_ids)
  end
end
