require "./mouse"

module Works
  class Tile
    Size = 32

    property row
    property col

    def initialize
      @row = 0
      @col = 0
    end

    def initialize(row, col)
      @row = row
      @col = col
    end

    def update(mouse : Mouse)
    end

    def draw(x, y)
      color = LibAllegro.map_rgba_f(0, 0.13, 0, 0.13)

      if (row % 2 != 0 && col % 2 != 0) || col % 2 == 0
        color = LibAllegro.map_rgba_f(0, 0, 0.13, 0.13)
      end

      draw(x, y, color)
    end

    def draw(x, y, color)
      x += col * Size
      y += row * Size

      LibAllegro.draw_filled_rectangle(x, y, x + Size, y + Size, color)
    end

    def destroy
    end

    def print
      puts "> Tile (#{row}, #{col})"
    end
  end
end
