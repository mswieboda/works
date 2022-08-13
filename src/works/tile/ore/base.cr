require "../base"

module Works::Tile::Ore
  abstract class Base < Tile::Base
    Name = "Ore"
    Color = LibAllegro.map_rgba_f(0.69, 0, 0.69, 0.69)
    HoverColor = LibAllegro.map_rgb_f(1, 1, 1)

    getter amount : UInt16

    def initialize(row = 0_u16, col = 0_u16, amount = 0_u16)
      super(row, col)

      @amount = amount
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def color
      self.class.color
    end

    def self.hover_color
      HoverColor
    end

    def hover_color
      self.class.hover_color
    end

    def draw(x, y)
      draw(x, y, color)
    end

    def draw_hover(dx, dy)
      dx += x
      dy += y

      LibAllegro.draw_rectangle(dx, dy, dx + width, dy + height, hover_color, 1)
    end

    def print_str
      "#{super} a: #{amount}"
    end

    def mine_amount(amount)
      @amount < amount ? @amount : amount
    end

    def mine(amount)
      removed = mine_amount(amount)

      @amount -= removed

      removed
    end
  end
end
