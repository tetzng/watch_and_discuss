# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room

  def index
    if valid_user?
      @message = Message.new
      @messages = @room.messages.includes(:user, :like).order('created_at desc')
      @elasped_time = Time.zone.now - @room.play_start_time if @room.play_started?
      respond_to do |format|
        format.html
        format.json
      end
    else
      redirect_to @room, flash: { notice: '部屋に参加できませんでした' }
    end
  end

  def create
    if valid_user?
      @message = @room.messages.new(create_params)
      if @message.save
        redirect_to room_messages_path, flash: { success: 'メッセージを作成しました' }
      else
        @messages = @room.messages.includes(:user, :like).order('created_at desc')
        flash.now[:error] = '作成に失敗しました'
        render 'index'
      end
    else
      redirect_to @room, flash: { notice: '作成できませんでした' }
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def valid_user?
    @room.owner == current_user || @room.members.include?(current_user)
  end

  def create_params
    params.require(:message).permit(:body).merge(user_id: current_user.id)
  end
end
