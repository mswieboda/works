require "../base"

module Works::Struct::Furnace
  abstract class Base < Struct::Base
    Key = :furnace
    Name = "furnace"
    Dimensions = {x: 2, y: 2}
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    # HUD
    OutputProgressColor = LibAllegro.premul_rgba_f(0, 1, 0, 0.33)

    property input_item : Item::Base | Nil
    property output_item : Item::Base | Nil
    getter working_item : Item::Base | Nil
    getter output_timer
    getter? input_slot_hover
    getter? output_slot_hover

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @input_item = nil
      @output_item = nil
      @output_timer = Timer.new(0.seconds)
      @working_item = nil
      @input_slot_hover = false
      @output_slot_hover = false
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.color
      Color
    end

    def item_class
      case key
      when :stone_furnace
        Item::Struct::Furnace::Stone
      when :electric_furnace
        Item::Struct::Furnace::Electric
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def grab_item
      output_item
    end

    def grab_item(item_grab_size)
      if item = grab_item
        leftovers = item.remove(item_grab_size)

        if item.amount <= 0
          @output_item = nil
        end

        leftovers
      end
    end

    def add_input?(item)
      return false unless accept_input?(item)

      if input_item = @input_item
        !input_item.full? && input_item.class == item.class
      else
        true
      end
    end

    def add_input(klass, amount)
      if input_item = @input_item
        input_item.add(amount)
      else
        item = klass.new
        leftovers = item.add(amount)

        @input_item = item

        leftovers
      end
    end

    def accept_input?(item : Item::Base)
      case item
      when Item::Ore::Copper, Item::Ore::Iron, Item::IronPlate, Item::Ore::Stone
        true
      else
        false
      end
    end

    def accept_output?(item : Item::Base)
      case item
      when Item::CopperPlate, Item::IronPlate, Item::SteelPlate, Item::StoneBrick
        true
      else
        false
      end
    end

    def update(map : Map)
      if working = @working_item
        if @output_timer.done?
          if create_output(working)
            @output_timer.stop
          else
            @output_timer.pause
          end
        end
      elsif input = input_item
        if output = output_item
          if output.full?
            @output_timer.stop

            return
          end
        end

        init_timer(input)
        burn_item(input)
      else
        @output_timer.stop
      end
    end

    def init_timer(item : Item::Base)
      duration = output_duration(item)

      if @output_timer.duration != duration
        @output_timer.stop
        @output_timer.duration = duration
      end

      @output_timer.start
    end

    def burn_item(item : Item::Base)
      klass = case item
      when Item::Ore::Copper
        Item::CopperPlate
      when Item::Ore::Iron
        Item::IronPlate
      when Item::IronPlate
        Item::SteelPlate
      when Item::Ore::Stone
        Item::StoneBrick
      else
        Item::Base
      end

      amount = case item
      when Item::Ore::Copper, Item::Ore::Iron
        1
      when Item::IronPlate
        5
      when Item::Ore::Stone
        2
      else
        1
      end

      if item.amount >= amount
        working = klass.new

        item.remove(amount)
        working.add(1)

        @working_item = working

        if item.none?
          @input_item = nil
        end
      end
    end

    def create_output(working_item : Item::Base)
      if output = output_item
        if output.class == working_item.class
          amount = working_item.amount
          leftovers = output.add(amount)

          if leftovers > 0
            working_item.remove(amount - leftovers)
          else
            @working_item = nil
          end
        else
          return false
        end
      else
        @output_item = working_item
        @working_item = nil
      end

      true
    end

    abstract def output_duration(item : Item::Base) : Time::Span

    # HUD

    def update_struct_info_slot_hovers(mouse, inventory_width, inventory_height)
      if hud_shown?
        @input_slot_hover = slot_hover?(input_slot_x, input_slot_y(inventory_height), mouse)
        @output_slot_hover = slot_hover?(output_slot_x(inventory_width), output_slot_y(inventory_height), mouse)
      end
    end

    def slot_click_held_item(inventory : Inventory, held_item : Item::Held)
      if input_slot_hover? && accept_input?(held_item.item)
        if item = input_item
          @input_item = inventory.swap_held_item(held_item, item)
        elsif item = inventory.remove_held_item
          @input_item = item
        end
      elsif output_slot_hover? && accept_output?(held_item.item)
        if item = output_item
          @output_item = inventory.swap_held_item(held_item, item)
        elsif item = inventory.remove_held_item
          @output_item = item
        end
      end
    end

    def slot_click_grab_item(inventory : Inventory, mouse : Mouse)
      if input_slot_hover? && (item = input_item)
        inventory.grab_slot_item(item, mouse)
        @input_item = nil
      elsif output_slot_hover? && (item = output_item)
        inventory.grab_slot_item(item, mouse)
        @output_item = nil
      end
    end

    def input_slot_x
      hud_x
    end

    def input_slot_y(inventory_height)
      hud_y(inventory_height) + hud_margin
    end

    def output_slot_x(inventory_width)
      hud_x + inventory_width - hud_margin - hud_slot_size
    end

    def output_slot_y(inventory_height)
      input_slot_y(inventory_height)
    end

    def fuel_slot_x
      input_slot_x
    end

    def fuel_slot_y(inventory_height)
      input_slot_y(inventory_height) + hud_margin + hud_slot_size
    end

    def draw_struct_info_slots(inventory_width, inventory_height)
      # input slot
      is_x = input_slot_x
      is_y = input_slot_y(inventory_height)
      InventoryHUD.draw_slot(is_x, is_y, input_item, input_slot_hover?)

      # output progress
      os_x = output_slot_x(inventory_width)
      px = is_x + hud_slot_size + hud_margin
      py = is_y + hud_margin * 3
      progress_total_x = os_x - hud_margin
      progress_width = progress_total_x - px
      progress_end_x = px + progress_width * output_timer.percent
      LibAllegro.draw_filled_rectangle(px, py, progress_end_x, py - hud_margin * 3 + hud_slot_size - hud_margin * 3, OutputProgressColor)

      # output slot
      InventoryHUD.draw_slot(os_x, output_slot_y(inventory_height), output_item, output_slot_hover?)
    end
  end
end
