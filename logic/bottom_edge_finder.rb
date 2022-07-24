require_relative 'finder_base'

class BottomEdgeFinder < FinderBase
  def initialize(noise_level_threshold, max_roll_down)
    @max_roll_down = max_roll_down
    super(noise_level_threshold)
  end

  def find(radar, invader)
    results = []

    max_column = radar.width - invader.width

    (1..max_roll_down).each do |current_offset|
      start_radar_row = radar.height - invader.height + current_offset
      (0..max_column).each do |column_idx|
        noise_level = invader.with_each_coord.sum do |invader_vector|
          next 0 if invader_vector.y > invader.height - current_offset - 1
          radar_signal = radar.at(column_idx + invader_vector.x, invader_vector.y + start_radar_row)
          invader_signal = invader.at(invader_vector.x, invader_vector.y)
          calculate_noise_level(radar_signal, invader_signal)
        end
        if noise_level <= noise_level_threshold
          results << Vector.new(column_idx, start_radar_row)
        end
      end
    end

    results
  end

  def label
    :partial_bottom_edge
  end

  private

  attr_reader :max_roll_down
end
