require "../cell"

module Works::Struct
  abstract class Base < Cell
    Key = :struct
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

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
