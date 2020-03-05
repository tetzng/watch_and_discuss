# frozen_string_literal: true

class RoomsController < ApplicationController
  def index
    @unstarted_rooms = Room.unstarted
    @ended_rooms = Room.ended
  end
end
