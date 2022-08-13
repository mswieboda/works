require "./tile"

module Works
  class Coal < Tile
    Color = LibAllegro.map_rgba_f(0.13, 0.13, 0.13, 0.69)
    HoverColor = LibAllegro.map_rgb_f(1, 1, 1)

    getter amount : UInt16

    def initialize(row = 0_u16, col = 0_u16, amount = 0_u16)
      super(row, col)

      @amount = amount
    end

    def draw(x, y)
      draw(x, y, Color)
    end

    def draw_hover(dx, dy)
      dx += x
      dy += y

      LibAllegro.draw_rectangle(dx, dy, dx + width, dy + height, HoverColor, 1)
    end

    def print
      puts "> Coal (#{row}, #{col}) a: #{amount}"
    end

    def mine(amount)
      removed = amount

      if @amount >= amount
        @amount -= amount
      else
        removed = @amount
        @amount = 0
      end

      removed
    end
  end
end
