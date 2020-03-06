# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_members
  has_many :members, through: :room_members
  belongs_to :owner, class_name: 'User'

  scope :unstarted, -> { where('start_time > ?', Time.zone.now) }
  scope :ended, -> { where('end_time < ?', Time.zone.now) }

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_is_after_current_time
  validate :end_time_is_after_start_time
  validate :periods_must_not_overlap

  def all_members_size
    members.size + 1
  end

  private

  def start_time_is_after_current_time
    return unless start_time && end_time

    errors.add(:start_time, 'は現在時刻よりも後に設定してください') if start_time < Time.zone.now
  end

  def end_time_is_after_start_time
    return unless start_time && end_time

    errors.add(:end_time, 'は開始時刻よりも後に設定してください') if start_time > end_time
  end

  def periods_must_not_overlap
    return unless start_time && end_time

    errors[:base] << '既に作成している部屋と期間が重複しています' if owner.own_rooms&.where('end_time > ? and ? > start_time', start_time, end_time).present?
  end
end
