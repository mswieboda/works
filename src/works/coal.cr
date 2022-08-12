require "./tile"

module Works
  class Coal < Tile
    Size = Tile::Size

    property? hover

    def initialize
      super

      @hover = false
    end

    def initialize(row, col)
      super(row, col)

      @hover = false
    end

    def update(mouse : Mouse)
      @hover = false

      if mouse.x >= col * Size && mouse.x <= col * Size + Size &&
         mouse.y >= row * Size && mouse.y <= row * Size + Size
        @hover = true
      end
    end

    def draw(x, y)
      color = LibAllegro.map_rgba_f(0.13, 0.13, 0.13, 0.69)

      draw(x, y, color)
      draw_hover(x, y, LibAllegro.map_rgb_f(1, 1, 1)) if hover?
    end

    def draw_hover(x, y, color)
      x += col * Size
      y += row * Size

      LibAllegro.draw_rectangle(x, y, x + Size, y + Size, color, 1)
    end

    def print
      puts "> Coal (#{row}, #{col}) h: #{@hover}"
    end
  end
end
