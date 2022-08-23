require "../base"

module Works::Struct::TransportBelt
  class Base < Struct::Base
    Key = :transport_belt
    Name = "Transport belt"
    BackgroundColor = LibAllegro.map_rgb_f(0.33, 0.33, 0.33)
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0)
    BeltSpeed = 1
    LaneDensity = 4
    ItemSlotHeight = 8 * Screen.scale_factor

    @@position = 0

    getter facing
    getter item_lane : Array(Item::Base | Nil)

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @facing = :down
      @item_lane = Array(Item::Base | Nil).new(LaneDensity, nil)
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
      when :express_transport_belt
        Item::Struct::TransportBelt::Express
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def update(map : Map)
      if position % ItemSlotHeight / 2 == 0
        if item_lane.first.nil?
          # shift all items to the left
          item_lane.rotate!
        end
      end
    end

    def grab_item
      # TODO: implement
      nil
    end

    def grab_item(item_grab_size)
      # TODO: implement
    end

    def add_input?(item : Item::Base)
      item_lane.any?(&.nil?)
    end

    def add_input(klass, amount)
      # Note: inserters always put on the 2nd spot
      # (when transport belt facing down) skipping the first
      # in :down, the 2nd spot is reverse, index #2
      if item_lane[2].nil?
        item = klass.new
        item.add(1)
        item_lane[2] = item

        amount - item.amount
      else
        amount
      end
    end

    def draw(dx, dy)
      draw(dx, dy, background_color)
      draw_accents(dx, dy, color)
      draw_lanes(dx, dy)
    end

    def draw_accents(dx, dy, color)
      dx += x
      dy += y
      px = dx
      py = dy + position - height
      h = height / 8

      6.times do |i|
        if py + h >= dy && py <= dy + height
          LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py + h, color, 3)
        end

        py += height / 3
      end
    end

    def draw_lanes(dx, dy)
      cx = dx + x + width / 2
      cy = dy + y + height / 2 - ItemSlotHeight / 2

      item_lane.reverse.each_with_index do |item, index|
        # cy += position % ItemSlotHeight

        if item
          item.draw_item(cx, cy)
        end

        cy += ItemSlotHeight
      end
    end
  end
end
