require "../cell"

module Works::Struct
  class Base < Cell
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    def self.name
      Name
    end

    def self.color
      Color
    end

    def color
      self.class.color
    end

    def draw(x, y)
      draw(x, y, color)
    end

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def destroy
    end
  end
end
