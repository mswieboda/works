require "../base"

module Works::Struct::TransportBelt
  class Base < Struct::Base
    Key = :transport_belt
    Name = "Transport belt"
    BackgroundColor = LibAllegro.map_rgb_f(0.33, 0.33, 0.33)
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0)
    BeltSpeed = 1

    @@position = 0

    getter facing

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @facing = :down
    end

    def self.update
      @@position += belt_speed

      if position > Cell.size
        @@position = 0_f64
      end
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.background_color
      BackgroundColor
    end

    def background_color
      self.class.background_color
    end

    def self.belt_speed
      BeltSpeed
    end

    def belt_speed
      self.class.belt_speed
    end

    def self.position
      @@position
    end

    def position
      self.class.position
    end

    def item_class
      case key
      when :transport_belt
        Item::Struct::TransportBelt::Base
      when :fast_transport_belt
        Item::Struct::TransportBelt::Fast
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def update(map : Map)

    end

    def grab_item(item_grab_size)
      # TODO: implement
    end

    def draw(dx, dy)
      draw(dx, dy, background_color)
      draw_accents(dx, dy, color)
    end

    def draw_accents(dx, dy, color)
      dx += x
      dy += y + position + height / 8

      3.times do |i|
        LibAllegro.draw_triangle(dx + width / 4, dy, dx + width - width / 4, dy, dx + width / 2, dy + height / 8, color, 3)

        dy += height / 3
      end
    end
  end
end
