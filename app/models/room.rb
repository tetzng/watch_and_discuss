# frozen_string_literal: true

class Room < ApplicationRecord
  scope :unstarted, -> { where('start_time > ?', Time.zone.now) }
  scope :ended, -> { where('end_time < ?', Time.zone.now) }
end
