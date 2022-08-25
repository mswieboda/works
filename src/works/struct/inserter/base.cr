require "../base"

module Works::Struct::Inserter
  abstract class Base < Struct::Base
    Key = :inserter
    Name = "inserter"
    Color = LibAllegro.map_rgb_f(1, 0, 1)
    RotationSpeed = 180 # degrees per second

    # drawing
    ArmWidth = (Cell.size / 8).to_i
    ArmLength = Cell.size

    property item : Item::Base | Nil
    getter? item_slot_hover
    getter facing
    getter rotation_timer

    protected setter facing

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @item = nil
      @item_slot_hover = false
      @facing = :right
      @rotation_timer = Timer.new((180 / rotation_speed).seconds, true)
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

    def self.rotation_speed
      RotationSpeed
    end

    def rotation_speed
      self.class.rotation_speed
    end

    def clone
      inserter = self.class.new(col, row)
      inserter.facing = @facing
      inserter
    end

    def rotate
      @facing = facing == :right ? :left : :right
    end

    def item_class
      case key
      when :burner_inserter
        Item::Struct::Inserter::Burner
      when :inserter
        Item::Struct::Inserter::Inserter
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def item_grab_size
      1
    end

    def update(map : Map)
      return unless rotation_timer.done?

      if item = @item
        if strct = struct_to_input_into(map)
          if strct.add_from_inserter?(item, facing)
            leftovers = strct.add_from_inserter(item.class, item.amount, facing)

            item.remove(item.amount - leftovers)

            if item.none?
              rotation_timer.restart
              @item = nil
            end
          end
        end
      elsif strct = struct_to_grab_output_from(map)
        if grab_item = strct.grab_item
          if leftovers = strct.grab_item(item_grab_size)
            item = grab_item.class.new

            item.add(item_grab_size - leftovers)

            @item = item

            rotation_timer.restart
          end
        end
      end
    end

    def grab_item
      return nil unless rotation_timer.done?

      item
    end

    def grab_item(item_grab_size)
      if item = @item
        leftovers = item.remove(item_grab_size)

        if item.amount <= 0
          rotation_timer.restart
          @item = nil
        end

        leftovers
      end
    end

    def input_coords
      case facing
      when :right
        [col + 1, row]
      when :left
        [col - 1, row]
      when :up
        [col, row + 1]
      when :down
        [col, row - 1]
      else
        raise "#{self.class.name}#input_coords facing direction #{facing} not found"
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
        raise "#{self.class.name}#input_coords facing direction #{facing} not found"
      end
    end

    def struct_to_input_into(map : Map)
      col, row = output_coords
      map.structs.find(&.overlaps_input?(col, row))
    end

    def struct_to_grab_output_from(map : Map)
      col, row = input_coords
      map.structs.find(&.overlaps_output?(col, row))
    end

    def overlaps_input?(col, row)
      false
    end

    def overlaps_output?(col, row)
      output_col, output_row = output_coords

      col == output_col && row == output_row
    end

    def draw(x, y)
      draw_body(x, y)
      draw_arm(x, y)
      draw_item(x, y)
    end

    def draw_body(dx, dy)
      dx = dx + x + width / 2
      dy = dy + y + height / 2
      LibAllegro.draw_filled_circle(dx, dy, size / 4, color)
      LibAllegro.draw_line(dx, dy, dx, dy - size / 3 - ArmWidth, color, ArmWidth)
      LibAllegro.draw_line(dx, dy, dx - size / 3, dy + size / 3, color, ArmWidth)
      LibAllegro.draw_line(dx, dy, dx + size / 3, dy + size / 3, color, ArmWidth)
    end

    def arm_end_position(dx, dy)
      angle = 180 * rotation_timer.percent.clamp(0, 1)

      if facing == :right
        angle = 180 - angle if item.nil?
      elsif facing == :left
        angle = 180 - angle if item
      end

      dx += x + width / 2
      dy += y + height / 2 - size / 3

      x2 = dx + Math.cos(angle * Math::PI / 180) * ArmLength
      y2 = dy - Math.sin(angle * Math::PI / 180) * ArmLength

      [dx, dy, x2, y2]
    end

    def draw_arm(dx, dy)
      dx, dy, x2, y2 = arm_end_position(dx, dy)

      LibAllegro.draw_line(dx, dy, x2, y2, color, ArmWidth)
    end

    def draw_item(dx, dy, center = true)
      if item = @item
        dx, dy, x2, y2 = arm_end_position(dx, dy)

        item.draw_item(x2, y2, center: center)
      end
    end

    # HUD

    def update_struct_info_slot_hovers(mouse, inventory_width, inventory_height)
      if hud_shown?
        @item_slot_hover = slot_hover?(item_slot_x, item_slot_y(inventory_height), mouse)
      end
    end

    def slot_click_held_item(inventory : Inventory, held_item : Item::Held)
      return unless item.nil? && item_slot_hover? && accept_item?(held_item.item)

      held_item.item.remove(item_grab_size)

      new_item = held_item.item.class.new

      new_item.add(item_grab_size)

      @item = new_item

      rotation_timer.restart if rotation_timer.done?

      inventory.remove_held_item if held_item.item.amount <= 0
    end

    def slot_click_grab_item(inventory : Inventory, mouse : Mouse)
      if item_slot_hover? && (item = @item)
        inventory.grab_slot_item(item, mouse)

        rotation_timer.restart if rotation_timer.done?

        @item = nil
      end
    end

    def item_slot_x
      hud_x + hud_margin
    end

    def item_slot_y(inventory_height)
      hud_y(inventory_height) + hud_margin + hud_margin
    end

    def draw_struct_info_slots(inventory_width, inventory_height)
      # item slot
      InventoryHUD.draw_slot(item_slot_x, item_slot_y(inventory_height), item, item_slot_hover?)
    end
  end
end
