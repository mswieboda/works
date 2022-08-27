require "../base"

module Works::Struct::TransportBelt
  class Base < Struct::Base
    Key = :transport_belt
    Name = "Transport belt"
    BackgroundColor = LibAllegro.map_rgb_f(0.33, 0.33, 0.33)
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0)
    BeltSpeed = 1
    LaneDensity = 4
    ItemSlotTicks = 8 * Screen.scale_factor

    alias ItemData = {item: Item::Base, position: UInt8}

    @@position = 0
    @@sheet = LibAllegro.load_bitmap("./assets/struct/transport_belt.png")
    @@animation = Animation.new(2)

    getter lanes : Tuple(Array(ItemData | Nil), Array(ItemData | Nil))
    getter facing
    getter turning_from : Symbol | Nil

    protected setter facing
    protected setter turning_from

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @lanes = {
        Array(ItemData | Nil).new(LaneDensity, nil),
        Array(ItemData | Nil).new(LaneDensity, nil)
      }
      @facing = :up
      @turning_from = nil
    end

    def self.update
      @@position += belt_speed

      if position > Cell.size
        @@position = 0_f64
      end

      @@animation.update
    end

    def self.init_animation
      size = 64
      frames = 8

      frames.times do |i|
        @@animation.add(@@sheet, i * size, 0, size, size)
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
      case facing
      when :up
        @facing = :right
      when :right
        @facing = :down
      when :down
        @facing = :left
      when :left
        @facing = :up
      else
        raise "> #{name}#rotate can't find next direction for #{facing}"
      end
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
      lanes.each_with_index do |lane, lane_index|
        lane.each_with_index do |item_data, index|
          if data = item_data
            if data[:position] < ItemSlotTicks - belt_speed.to_u8
              increase_item_data_position(lane_index, index, data)
            end

            if data[:position] >= ItemSlotTicks - belt_speed.to_u8
              move_item_on_belt(lane_index, index, map, data)
            end
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

    def lane_from_inserter(inserter_facing : Symbol)
      if facing == :down
        if inserter_facing == :left
          # right of belt
          lanes[1]
        else
          # left of belt
          lanes[0]
        end
      elsif facing == :up
        if inserter_facing == :right
          # left of belt
          lanes[1]
        else
          # right of belt
          lanes[0]
        end
      elsif facing == :left
        if inserter_facing == :up
          # bottom of belt
          lanes[1]
        else
          # top of belt
          lanes[0]
        end
      else # facing :right
        if inserter_facing == :down
          # top of belt
          lanes[1]
        else
          # bottom of belt
          lanes[0]
        end
      end
    end

    def add_from_inserter?(item : Item::Base, inserter_facing : Symbol)
      lane_from_inserter(inserter_facing).any?(&.nil?)
    end

    def add_from_inserter(klass, amount, inserter_facing : Symbol)
      # Note: inserters always put on the 2nd spot, skipping the first
      #       since index is in revserse, it's LaneDensity - 1
      #       and - 1 again because it's indexed from 0, so LaneDensity - 2
      lane = lane_from_inserter(inserter_facing)

      if lane[LaneDensity - 2].nil?
        item = klass.new
        item.add(1)
        lane[LaneDensity - 2] = {item: item, position: 0_u8}

        amount - item.amount
      else
        amount
      end
    end

    def output_coords
      case facing
      when :right
        [col + 1, row]
      when :left
        [col - 1, row]
      when :up
        [col, row - 1]
      when :down
        [col, row + 1]
      else
        raise "#{self.class.name}#output_coords facing direction #{facing} not found"
      end
    end

    def input_coords
      case facing
      when :right
        [col - 1, row]
      when :left
        [col + 1, row]
      when :up
        [col, row + 1]
      when :down
        [col, row - 1]
      else
        raise "#{self.class.name}#output_coords facing direction #{facing} not found"
      end
    end

    def find_belt(map : Map, col, row)
      map
        .structs
        .select(&.is_a?(Struct::TransportBelt::Base))
        .find(&.overlaps_input?(col, row))
        .as(Struct::TransportBelt::Base | Nil)
    end

    def output_belt(map : Map)
      col, row = output_coords
      find_belt(map, col, row)
    end

    def input_belt(map : Map)
      col, row = input_coords
      find_belt(map, col, row)
    end

    def increase_item_data_position(lane_index, index, data : ItemData)
      lanes[lane_index][index] = {item: data[:item], position: data[:position] + belt_speed.to_u8}
    end

    def move_item_on_belt(lane_index, index, map : Map, data : ItemData)
      if index == 0
        if belt = output_belt(map)
          move_to_belt(belt, lane_index, index, data[:item])
        end
      elsif lanes[lane_index][index - 1].nil?
        lanes[lane_index][index - 1] = {item: data[:item], position: 0_u8}
        lanes[lane_index][index] = nil
      end
    end

    def move_to_belt(belt : Struct::TransportBelt::Base, lane_index, index, item : Item::Base)
      if belt.can_receive_from_belt?(lane_index, facing)
        belt.receive_from_belt(lane_index, item)
        lanes[lane_index][index] = nil
      end
    end

    def can_receive_from_belt?(lane_index, facing)
      # TODO: For now always assume last index (3), and up/down
      # but later, depending on belt directions, use a different output index
      @facing == facing && lanes[lane_index][LaneDensity - 1].nil?
    end

    def receive_from_belt(lane_index, item)
      # TODO: For now always assume last index (3), and facing up/down
      # but later, depending on belt directions, use a different output index
      lanes[lane_index][LaneDensity - 1] = {item: item, position: 0_u8}
    end

    def update_turning_from(input_facing : Symbol, map : Map)
      @turning_from = nil

      if belt = input_belt(map)
        return if facing == belt.facing
      end

      if facing_horizontal? && (input_facing == :up || input_facing == :down)
        if input_facing == :up
          check_row = row - 1

          if other_belt = find_belt(map, col, check_row)
            return if other_belt.facing == :down
          end
        elsif input_facing == :down
          check_row = row + 1

          if other_belt = find_belt(map, col, check_row)
            return if other_belt.facing == :up
          end
        end

        @turning_from = input_facing
      elsif facing_vertical? && (input_facing == :right || input_facing == :left)
        if input_facing == :right
          check_col = col + 1

          if other_belt = find_belt(map, check_col, row)
            return if other_belt.facing == :left
          end
        elsif input_facing == :left
          check_col = col - 1

          if other_belt = find_belt(map, check_col, row)
            return if other_belt.facing == :right
          end
        end

        @turning_from = input_facing
      end
    end

    def facing_horizontal?
      facing == :right || facing == :left
    end

    def facing_vertical?
      facing == :up || facing == :down
    end

    def perpendicular?(other_facing : Symbol)
      if facing_vertical?
        other_facing == :left || other_facing == :right
      else # facing horizontal
        other_facing == :down || other_facing == :up
      end
    end

    def check_perpendicular_input_belts(map : Map)
      @turning_from = nil

      if belt = input_belt(map)
        return if facing == belt.facing
      end

      if facing_vertical?
        if belt = find_belt(map, col - 1, row)
          @turning_from = belt.facing if belt.facing == :right
        end

        if belt = find_belt(map, col + 1, row)
          if belt.facing == :left
            @turning_from = @turning_from ? nil : belt.facing
          end
        end
      else # facing horizontal
        if belt = find_belt(map, col, row - 1)
          @turning_from = belt.facing if belt.facing == :down
        end

        if belt = find_belt(map, col, row + 1)
          if belt.facing == :up
            @turning_from = @turning_from ? nil : belt.facing
          end
        end
      end
    end

    def update_turning_belts(map : Map)
      if belt = input_belt(map)
        if belt.facing == facing
          @turning_from = nil

          return
        end
      end

      check_perpendicular_input_belts(map)

      if belt = output_belt(map)
        if perpendicular?(belt.facing)
          belt.update_turning_from(facing, map)
        elsif facing = belt.facing
          belt.turning_from = nil
        end
      end
    end

    def remove_belt_update_turning_belts(map : Map)
      if belt = output_belt(map)
        belt.update_turning_belts(map)
      end

      if belt = input_belt(map)
        if perpendicular?(belt.facing)
          belt.update_turning_belts(map)
        end
      end
    end

    def draw(dx, dy)
      draw_background(dx, dy)
      draw_accents(dx, dy, color)
      draw_lanes(dx, dy)

      draw_turning_text(dx, dy) if turning_from
    end

    def draw_background(dx, dy)
      if facing_vertical?
        @@animation.draw(dx + x, dy + y, flip_horizontal: false, flip_vertical: facing == :down)
      else
        @@animation.draw_rotated(dx + x, dy + y, angle: 90, flip_horizontal: false, flip_vertical: facing == :left)
      end
    end

    def draw_accents(dx, dy, color)
      dx += x
      dy += y
      px = dx
      py = dy
      h = size / 8

      if facing_vertical?
        px -= 2 * Screen.scale_factor
      else
        py -= 2 * Screen.scale_factor
      end

      if facing == :down
        py = py - height + position

        6.times do |i|
          if py + h >= dy && py <= dy + height
            LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py + h, color, 3)
          end

          py += height / 3
        end
      elsif facing == :up
        py = py + height * 2 - position

        6.times do |i|
          if py - h <= dy + height && py >= dy
            LibAllegro.draw_triangle(px + width / 4, py, px + width - width / 4, py, px + width / 2, py - h, color, 3)
          end

          py -= height / 3
        end
      elsif facing == :right
        px = px - width + position

        6.times do |i|
          if px + h >= dx && px < dx + width
            LibAllegro.draw_triangle(px, py + height / 4, px, py + height - height / 4, px + h, py + height / 2, color, 3)
          end

          px += width / 3
        end
      elsif facing == :left
        px = px + width * 2 - position

        6.times do |i|
          if px - h <= dx + width && px >= dx
            LibAllegro.draw_triangle(px, py + height / 4, px, py + height - height / 4, px - h, py + height / 2, color, 3)
          end

          px -= width / 3
        end
      end
    end

    def draw_lanes(dx, dy)
      dx = dx + x
      dy = dy + y

      lanes.each_with_index do |item_lane, lane_index|
        lane = item_lane

        ix = dx
        iy = dy

        if facing == :down
          lane = lane.reverse
          ix += lane_index * width / 2
          iy -= ItemSlotTicks
        elsif facing == :up
          ix += (1 - lane_index) * width / 2
        elsif facing == :right
          lane = lane.reverse
          ix -= ItemSlotTicks
          iy += (1 - lane_index) * height / 2
        elsif facing == :left
          iy += lane_index * height / 2
        end

        lane.each_with_index do |item_data, index|
          if item_data
            px = ix
            py = iy

            if facing == :down
              py = iy + item_data[:position]
            elsif facing == :up
              py = iy - item_data[:position]
            elsif facing == :right
              px = ix + item_data[:position]
            elsif facing == :left
              px = ix - item_data[:position]
            end

            item_data[:item].draw_item(px, py, center: false)
          end

          iy += ItemSlotTicks if facing == :down || facing == :up
          ix += ItemSlotTicks if facing == :right || facing == :left
        end
      end
    end

    def draw_turning_text(dx, dy)
      str = "#{facing.to_s.chars.first.upcase}"

      if turning_from = @turning_from
        str += turning_from.to_s.chars.first.upcase
      end

      LibAllegro.draw_text(Font.default, LibAllegro.map_rgb_f(1, 0, 1), dx + x, dy + y, 0, str)
    end

    def self.destroy
      @@animation.destroy
      LibAllegro.destroy_bitmap(@@sheet)
    end
  end
end
