class CreateRoomMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :room_members do |t|
      t.references :room, foreign_key: true
      t.references :member, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
