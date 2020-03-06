# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]

  def index
    @unstarted_rooms = Room.unstarted.includes(:members)
    @ended_rooms = Room.ended.includes(:members)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(create_params)
    if @room.save
      redirect_to rooms_path, flash: { success: '部屋を作成しました' }
    else
      flash.now[:error] = '作成に失敗しました'
      render 'new'
    end
  end

  private

  def create_params
    params.require(:room).permit(:title, :start_time, :end_time)
          .merge(owner_id: current_user.id)
  end
end
