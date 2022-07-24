class MapData
  attr_accessor :width, :height, :lines

  def at(col, row)
    lines[row][col]
  end

  def with_each_coord
    Enumerator.new do |yielder|
      (0..height - 1).each do |row|
        (0..width - 1).each do |col|
          yielder << Vector.new(col, row)
        end
      end
    end
  end
end
