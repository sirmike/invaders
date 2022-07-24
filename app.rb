class App
  def initialize(file_reader:, data_parser:)
    @file_reader = file_reader
    @data_parser = data_parser
    @invaders = []
    @finders = []
  end

  def init_radar_from_path(radar_path)
    @radar = data_parser.parse(file_reader.read(radar_path))
  end

  def add_invader_from_path(invader_path)
    @invaders << data_parser.parse(file_reader.read(invader_path))
  end

  def add_finder(finder)
    @finders << finder
  end

  def run
    invaders.each do |invader|
      puts
      puts 'Looking for:'
      print_map(invader)

      puts
      puts 'Coordinates:'
      finders.each do |finder|
        result = finder.find(radar, invader)
        if result.empty?
          puts "[#{finder.label}] not found"
        else
          for r in result
            puts "[#{finder.label}] X:#{r.x}, Y:#{r.y}"
          end
        end
      end
    end
  end

  private

  attr_reader :file_reader, :data_parser, :invaders, :finders, :radar

  def print_map(map)
    puts map.lines.slice(0, map.lines.length)
  end
end
