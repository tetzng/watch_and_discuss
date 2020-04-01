# frozen_string_literal: true

class AddColumnToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :play_start_time, :datetime
  end
end
