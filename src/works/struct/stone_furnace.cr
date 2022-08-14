require "./base"
require "../item/struct/stone_furnace"

module Works::Struct
  class StoneFurnace < Base
    Name = "Stone furnace"
    Dimensions = {x: 2, y: 2}
    Color = Item::Struct::StoneFurnace::Color
    HoverColor = LibAllegro.map_rgb_f(1, 1, 1)

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.item_class
      Item::Struct::StoneFurnace
    end

    def self.color
      Color
    end

    def self.hover_color
      HoverColor
    end

    def hover_color
      self.class.hover_color
    end

    def draw_hover(dx, dy)
      dx += x
      dy += y

      LibAllegro.draw_rectangle(dx, dy, dx + width, dy + height, hover_color, 1)
    end
  end
end
