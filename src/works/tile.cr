require "./mouse"

module Works
  class Tile
    Size = 32_u8
    OddColor = LibAllegro.map_rgba_f(0, 0.13, 0, 0.13)
    EvenColor = LibAllegro.map_rgba_f(0, 0, 0.13, 0.13)

    property row : UInt16
    property col : UInt16

    def initialize(row = 0_u16, col = 0_u16)
      @row = row
      @col = col
    end

    def self.size
      Size
    end

    def size
      self.class.size
    end

    def draw(x, y)
      same = [row, col].all?(&.odd?) || [row, col].all?(&.even?)

      draw(x, y, same ? OddColor : EvenColor)
    end

    def draw(x, y, color)
      x += col * size
      y += row * size

      LibAllegro.draw_filled_rectangle(x, y, x + size, y + size, color)
    end

    def destroy
    end

    def print
      puts "> Tile (#{row}, #{col})"
    end
  end
end
