# frozen_string_literal: true

if @room.starting?
  elasped_time = if @room.play_started?
                   Time.zone.now - @room.play_start_time
                 else
                   0
                 end
  json.elasped_time Time.at(elasped_time).utc.strftime('%X')
end
