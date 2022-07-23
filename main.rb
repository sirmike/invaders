require 'active_support/core_ext/string'

ERROR_TOLERANCE_PERCENTAGE = 25

class FileReader
  def read(file_path)
    return IO.readlines(file_path, chomp: true)
  end
end

class MapData
  attr_accessor :width, :height, :lines, :max_score
end

class DataParser
  def parse(lines)
    first_line = lines.first
    result = MapData.new.tap do |d|
      d.width = first_line.length
      d.height = lines.count
      d.lines = lines
      d.max_score = d.width * d.height
    end
    result
  end
end

class Invader
  attr_reader :data

  def initialize(data)
    @data = data
  end
end

class Radar
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def find(invader)
    results = {}
    score = 0
    offset_x = 0
    offset_y = 0

    slice_length = invader.data.lines.first.length
    while offset_y <= data.lines.length - invader.data.lines.length
      while offset_x <= data.lines.first.length - slice_length
        invader.data.lines.each_with_index do |invader_line, line_idx|
          invader_line.length.times do |character_idx|
            radar_c = data.lines[offset_y + line_idx].slice(offset_x + character_idx)
            if radar_c == invader_line[character_idx]
              score += 1
            end
          end
        end
        results[score] = [] unless results.has_key?(score)
        results[score] << [offset_x, offset_y]
        score = 0
        offset_x += 1
      end
      offset_y += 1
      offset_x = 0
    end
    results
  end
end

map_path = ARGV[0]
raise 'radar file path must be present' unless map_path.present?
invader_path = ARGV[1]
raise 'invader file path must be present' unless invader_path.present?

fr = FileReader.new
dp = DataParser.new

radar_data = dp.parse(fr.read(map_path))
invader_data = dp.parse(fr.read(invader_path))

puts 'Invader lookup:'
puts invader_data.lines
puts
puts 'Result:'

radar = Radar.new(radar_data)
result = radar.find(Invader.new(invader_data))
sorted = result.keys.sort
for s in sorted
  r = result[s]
  probability = s.to_f * 100.0 / invader_data.max_score
  if probability >= 100 - ERROR_TOLERANCE_PERCENTAGE
    puts "#{probability}%: (#{r[0]}, #{r[1]})"
  end
end
