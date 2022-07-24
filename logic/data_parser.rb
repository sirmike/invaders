class DataParser
  def parse(lines)
    validate_lines!(lines)
    result = MapData.new.tap do |d|
      d.width = lines.first.length
      d.height = lines.count
      d.lines = lines
    end
    result
  end

  private

  def validate_lines!(lines)
    validate_total_count!(lines)
    validate_rect_shape!(lines)
  end

  def validate_total_count!(lines)
    raise 'Lines cannot be empty' unless lines.length > 0
  end

  def validate_rect_shape!(lines)
    raise 'Lines must be the same length' if lines.map(&:length).uniq.length != 1
  end
end
