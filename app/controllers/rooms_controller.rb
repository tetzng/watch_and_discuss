# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @unstarted_rooms = Room.unstarted.includes(:members)
    @ended_rooms = Room.ended.includes(:members)
  end
end
