require_relative 'finder_base'

class FullScanFinder < FinderBase
  def find(invader)
    results = []

    max_column = radar.width - invader.width
    max_row = radar.height - invader.height

    (0..max_row).each do |row_idx|
      (0..max_column).each do |column_idx|
        noise_level = invader.with_each_coord.sum do |invader_vector|
          radar_signal = radar.at(column_idx + invader_vector.x, row_idx + invader_vector.y)
          invader_signal = invader.at(invader_vector.x, invader_vector.y)
          calculate_noise_level(radar_signal, invader_signal)
        end
        if noise_level <= noise_level_threshold
          results << Vector.new(column_idx, row_idx)
        end
      end
    end

    results
  end

  def label
    :full_scan
  end
end
