# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]

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

  def show
    @room = Room.includes(:members).find(params[:id])
  end

  def edit
    @room = current_user.own_rooms.find(params[:id])
  end

  def update
    @room = current_user.own_rooms.find(params[:id])

    if @room.update(update_params)
      redirect_to room_path, flash: { success: '部屋を更新しました' }
    else
      flash.now[:error] = '更新に失敗しました'
      render 'edit'
    end
  end

  def destroy
    @room = current_user.own_rooms.find(params[:id])

    if @room.destroy
      redirect_to rooms_path, flash: { success: '部屋を削除しました' }
    else
      flash.now[:error] = '削除に失敗しました'
      render 'edit'
    end
  end

  def join
    @room = Room.find(params[:id])

    if @room.owner == current_user || @room.members.include?(current_user)
      redirect_to room_path, flash: { success: '入室しました' }
    else
      @new_member = @room.room_members.new(member_id: current_user.id)
      if @new_member.save
        redirect_to room_path, flash: { success: '部屋に参加しました' }
      else
        flash.now[:error] = '参加できませんでした'
        render 'show'
      end
    end
  end

  private

  def create_params
    params.require(:room).permit(:title, :start_time, :end_time)
          .merge(owner_id: current_user.id)
  end

  def update_params
    params.require(:room).permit(:title, :start_time, :end_time)
  end
end
