# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :set_message

  def create
    @like = @message.build_like(user_id: current_user.id)

    if @like.save
      redirect_to room_messages_path(@room), flash: { success: 'いいねしました' }
    else
      redirect_to room_messages_path(@room), flash: { error: 'いいねは部屋の作成者のみ可能です' }
    end
  end

  def destroy
    if @like = current_user.likes.find_by(id: params[:id])
      @like.destroy
      redirect_to room_messages_path(@room), flash: { success: 'いいねを解除しました' }
    else
      redirect_to room_messages_path(@room), flash: { error: 'いいねの解除は部屋の作成者のみ可能です' }
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_message
    @message = @room.messages.find(params[:message_id])
  end
end
