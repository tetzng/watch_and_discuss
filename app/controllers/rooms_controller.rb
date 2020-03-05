# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @unstarted_rooms = Room.where('start_time > ?', Time.zone.now)
    @ended_rooms = Room.where('end_time < ?', Time.zone.now)
  end
end
