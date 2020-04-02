# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_members
  has_many :members, through: :room_members
  has_many :messages
  belongs_to :owner, class_name: 'User'

  scope :unstarted, -> { where('start_time > ?', Time.zone.now) }
  scope :starting, -> { where('start_time <= ? and end_time >= ?', Time.zone.now, Time.zone.now) }
  scope :ended, -> { where('end_time < ?', Time.zone.now) }

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  validate :start_time_is_after_current_time
  validate :end_time_is_after_start_time
  validate :periods_must_not_overlap_on_create, on: :create
  validate :periods_must_not_overlap_on_update, on: :update
  validate :cannot_be_changed_after_start_time, on: :update
  validate :cannot_be_changed_play_start_time, on: :update
  validate :play_start_time_is_after_start_time

  before_destroy :cannot_be_deleted_after_start_time

  def all_members_size
    members.size + 1
  end

  def play_started?
    play_start_time.present?
  end

  def starting?
    current_time = Time.zone.now
    start_time <= current_time && end_time >= current_time
  end

  def ended?
    end_time < Time.zone.now
  end

  private

  def start_time_is_after_current_time
    return unless start_time && end_time
    return unless will_save_change_to_start_time?

    errors.add(:start_time, 'は現在時刻よりも後に設定してください') if start_time < Time.zone.now
  end

  def end_time_is_after_start_time
    return unless start_time && end_time

    errors.add(:end_time, 'は開始時刻よりも後に設定してください') if start_time > end_time
  end

  def periods_must_not_overlap_on_create
    return unless start_time && end_time

    if owner.joined_rooms
        &.where('end_time > ? and ? > start_time', start_time, end_time).present?
      errors[:base] << '既に参加している部屋と期間が重複しています'
    end
  end

  def periods_must_not_overlap_on_update
    return unless will_save_change_to_start_time? || will_save_change_to_end_time?

    if owner.joined_rooms
        &.where('end_time > ? and ? > start_time and id != ?',
                start_time, end_time, id).present?
      errors[:base] << '既に参加している部屋と期間が重複しています'
    end
  end

  def cannot_be_changed_after_start_time
    return unless will_save_change_to_title? || will_save_change_to_start_time? || will_save_change_to_end_time?

    errors[:base] << '開始時刻を過ぎたため変更できません' if start_time_in_database < Time.zone.now
  end

  def cannot_be_changed_play_start_time
    return unless will_save_change_to_play_start_time? && play_start_time_in_database.present?

    errors[:base] << '既に再生開始しています'
  end

  def play_start_time_is_after_start_time
    return unless play_start_time

    errors[:base] << '開始時刻よりも前に再生開始できません' if start_time > play_start_time
  end

  def cannot_be_deleted_after_start_time
    return if start_time > Time.zone.now

    errors[:base] << '開始時刻を過ぎたため削除できません'
    throw :abort
  end
end
