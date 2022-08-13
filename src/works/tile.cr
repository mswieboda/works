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

    def width
      size
    end

    def height
      size
    end

    def x
      col * size
    end

    def y
      row * size
    end

    def draw(x, y)
      same = [row, col].all?(&.odd?) || [row, col].all?(&.even?)

      draw(x, y, same ? OddColor : EvenColor)
    end

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def destroy
    end

    def print
      puts "> Tile (#{row}, #{col})"
    end
  end
end
