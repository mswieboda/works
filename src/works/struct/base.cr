require "../cell"

module Works::Struct
  abstract class Base < Cell
    Key = :struct
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    property input_item : Item::Base | Nil
    property output_item : Item::Base | Nil
    property fuel_item : Item::Base | Nil

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @input_item = nil
      @output_item = nil
      @fuel_item = nil
    end

    def self.key
      Key
    end

    def key
      self.class.key
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

    abstract def item_class

    def draw(x, y)
      draw(x, y, color)
    end

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def draw_hover_info
      HUDText.new("#{name}").draw_from_bottom(0, Screen::Height)
    end

    def destroy
    end
  end
end
