#!/usr/bin/env ruby
require 'active_support/core_ext/string'
require_relative 'app'
require_relative 'models/map_data'
require_relative 'models/vector'
require_relative 'logic/data_parser'
require_relative 'logic/file_reader'
require_relative 'logic/full_scan_finder'
require_relative 'logic/top_edge_finder'
require_relative 'logic/bottom_edge_finder'

NOISE_LEVEL_THRESHOLD = 12
ROLL_LINES_MAX = 3

map_path = ARGV[0]
raise 'radar file path must be present' unless map_path.present?

file_reader = FileReader.new
data_parser = DataParser.new
full_scan_finder = FullScanFinder.new(NOISE_LEVEL_THRESHOLD)
top_edge_finder = TopEdgeFinder.new(NOISE_LEVEL_THRESHOLD, ROLL_LINES_MAX)
bottom_edge_finder = BottomEdgeFinder.new(NOISE_LEVEL_THRESHOLD, ROLL_LINES_MAX)

app = App.new(
  file_reader: file_reader,
  data_parser: data_parser
)
app.init_radar_from_path(map_path)
app.add_invader_from_path('./data/invader_1.txt')
app.add_invader_from_path('./data/invader_2.txt')
app.add_finder(full_scan_finder)
app.add_finder(top_edge_finder)
app.add_finder(bottom_edge_finder)
app.run
