require 'active_support/core_ext/string'
require_relative 'models/map_data'
require_relative 'models/vector'
require_relative 'logic/data_parser'
require_relative 'logic/file_reader'
require_relative 'logic/full_scan_finder'
require_relative 'logic/top_edge_finder'
require_relative 'logic/bottom_edge_finder'

def print_data(lines)
  puts lines.slice(0, lines.length)
end

NOISE_LEVEL_THRESHOLD = 12
ROLL_LINES_MAX = 3
INVADERS = ['./data/invader_1.txt', './data/invader_2.txt']

map_path = ARGV[0]
raise 'radar file path must be present' unless map_path.present?

file_reader = FileReader.new
data_parser = DataParser.new

radar = data_parser.parse(file_reader.read(map_path))

full_scan_finder = FullScanFinder.new(radar, NOISE_LEVEL_THRESHOLD)
top_edge_finder = TopEdgeFinder.new(radar, NOISE_LEVEL_THRESHOLD, ROLL_LINES_MAX)
bottom_edge_finder = BottomEdgeFinder.new(radar, NOISE_LEVEL_THRESHOLD, ROLL_LINES_MAX)
finders = [full_scan_finder, top_edge_finder, bottom_edge_finder]

puts "Calibrating noise level threshold: #{NOISE_LEVEL_THRESHOLD}"

INVADERS.each do |invader_data_path|
  invader = data_parser.parse(file_reader.read(invader_data_path))

  puts
  puts 'Looking for:'
  puts print_data(invader.lines)

  puts "Coordinates:"
  finders.each do |finder|
    result = finder.find(invader)
    if result.empty?
      puts "[#{finder.label}] not found"
    else
      for r in result
        puts "[#{finder.label}] X:#{r.x}, Y:#{r.y}"
      end
    end
  end
end
