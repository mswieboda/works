require "../cell"

module Works::Struct
  class Base < Cell
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)
    HoverColor = LibAllegro.map_rgb_f(0, 1, 0)

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

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def draw_hover(dx, dy)
      puts "> Struct::Base#draw_hover (#{dx}, #{dy})"
      dx += x
      dy += y

      LibAllegro.draw_rectangle(dx, dy, dx + width, dy + height, hover_color, 1)
    end

    def destroy
    end
  end
end
