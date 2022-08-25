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

    alias ItemData = {item: Item::Base, position: UInt8}

    @@position = 0

    getter facing
    getter item_lane : Array(ItemData | Nil)

    protected setter facing

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @facing = :down
      @item_lane = Array(ItemData | Nil).new(LaneDensity, nil)
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

    def clone
      belt = self.class.new(col, row)
      belt.facing = @facing
      belt
    end

    def position
      self.class.position
    end

    def rotate
      @facing = facing == :down ? :up : :down
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
      item_lane.each_with_index do |item_data, index|
        if data = item_data
          if data[:position] < ItemSlotHeight - belt_speed.to_u8
            increase_item_data_position(index, data)
          end

          if data[:position] >= ItemSlotHeight - belt_speed.to_u8
            move_item_on_belt(index, map, data)
          end
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
        item_lane[2] = {item: item, position: 0_u8}

        amount - item.amount
      else
        amount
      end
    end

    def output_coords
      case facing
      when :right
        [col - 1, row]
      when :left
        [col + 1, row]
      when :up
        [col, row - 1]
      when :down
        [col, row + 1]
      else
        raise "#{self.class.name}#output_coords facing direction #{facing} not found"
      end
    end

    def next_belt(map : Map)
      col, row = output_coords
      map.structs.select(&.is_a?(Struct::TransportBelt::Base)).find(&.overlaps_input?(col, row)).as(Struct::TransportBelt::Base | Nil)
    end

    def increase_item_data_position(index, data : ItemData)
      item_lane[index] = {item: data[:item], position: data[:position] + belt_speed.to_u8}
    end

    def move_item_on_belt(index, map : Map, data : ItemData)
      if index == 0
        if belt = next_belt(map)
          move_to_belt(belt, data[:item], index)
        end
      elsif item_lane[index - 1].nil?
        # shuffle item towards top of item_lane
        item_lane[index - 1] = {item: data[:item], position: 0_u8}
        item_lane[index] = nil
      end
    end

    def move_to_belt(belt : Struct::TransportBelt::Base, item : Item::Base, index)
      if belt.can_receive_from_belt?
        belt.receive_from_belt(item)
        item_lane[index] = nil
      end
    end

    def can_receive_from_belt?
      # TODO: For now always assume last index (3), and facing down
      # but later, depending on belt directions, use a different output index
      item_lane[LaneDensity - 1].nil?
    end

    def receive_from_belt(item)
      # TODO: For now always assume last index (3), and facing down
      # but later, depending on belt directions, use a different output index
      item_lane[LaneDensity - 1] = {item: item, position: 0_u8}
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
      py = dy
      h = height / 8

      if facing == :down
        py = py - height + position

        6.times do |i|
          if py + h >= dy && py <= dy + height
            LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py + h, color, 3)
          end

          py += height / 3
        end
      else
        py = py + height * 2 - position

        6.times do |i|
          if py - h <= dy + height && py >= dy
            LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py - h, color, 3)
          end

          py -= height / 3
        end
      end
    end

    def draw_lanes(dx, dy)
      dx = dx + x
      dy = dy + y - ItemSlotHeight

      item_lane.reverse.each_with_index do |item_data, index|
        if item_data
          iy = dy + item_data[:position]
          item_data[:item].draw_item(dx, iy, center: false)
        end

        dy += ItemSlotHeight
      end
    end
  end
end
