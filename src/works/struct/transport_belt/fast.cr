require "./base"

module Works::Struct::TransportBelt
  class Fast < Base
    Key = :fast_transport_belt
    Name = "Fast transport belt"
    Color = LibAllegro.map_rgb_f(0.75, 0, 0)
    BeltSpeed = 2

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.belt_speed
      BeltSpeed
    end

    def draw_accents(dx, dy, color)
      dx += x
      dy += y
      px = dx
      py = dy + position - height
      h = height / 8

      2.times do |i|
        if py + h >= dy && py <= dy + height
          LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py + h, color, 3)
        end

        py += height
      end
    end
  end
end
