# frozen_string_literal: true

class AddRefsToRooms < ActiveRecord::Migration[5.2]
  def change
    add_reference :rooms, :owner, foreign_key: { to_table: :users }
  end
end
