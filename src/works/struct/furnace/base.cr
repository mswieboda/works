require "../base"

module Works::Struct::Furnace
  abstract class Base < Struct::Base
    Key = :furnace
    Name = "furnace"
    Dimensions = {x: 2, y: 2}
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    # HUD
    Margin = 4 * Screen::ScaleFactor
    SlotSize = 32 * Screen::ScaleFactor
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)
    OutputProgressColor = LibAllegro.premul_rgba_f(0, 1, 0, 0.33)

    property input_item : Item::Base | Nil
    property output_item : Item::Base | Nil
    property fuel_item : Item::Base | Nil
    getter working_item : Item::Base | Nil
    getter output_timer
    getter? input_slot_hover
    getter? output_slot_hover
    getter? fuel_slot_hover

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @input_item = nil
      @output_item = nil
      @fuel_item = nil
      @output_timer = Timer.new(0.seconds)
      @working_item = nil
      @input_slot_hover = false
      @output_slot_hover = false
      @fuel_slot_hover = false
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

    def accept_input?(item : Item::Base)
      case item
      when Item::Ore::Copper, Item::Ore::Iron, Item::Ore::Stone, Item::IronPlate
        true
      else
        false
      end
    end

    def update
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
      when Item::Ore::Stone
        Item::StoneBrick
      when Item::IronPlate
        Item::SteelPlate
      else
        Item::Base
      end

      amount = case item
      when Item::Ore::Copper, Item::Ore::Iron
        1
      when Item::Ore::Stone
        2
      when Item::IronPlate
        5
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
        @fuel_slot_hover = slot_hover?(fuel_slot_x, fuel_slot_y(inventory_height), mouse)
      end
    end

    def slot_hover?(slot_x, slot_y, mouse : Mouse)
      mouse.x >= slot_x && mouse.x < slot_x + SlotSize &&
        mouse.y > slot_y && mouse.y < slot_y + SlotSize
    end

    def hud_x
      Screen::Width / 2
    end

    def hud_y(inventory_height)
      Screen::Height / 2 - inventory_height / 2
    end

    def input_slot_x
      hud_x + Margin
    end

    def input_slot_y(inventory_height)
      hud_y(inventory_height) + Margin + Margin
    end

    def output_slot_x(inventory_width)
      hud_x + inventory_width - Margin - SlotSize - Margin
    end

    def output_slot_y(inventory_height)
      input_slot_y(inventory_height)
    end

    def fuel_slot_x
      input_slot_x
    end

    def fuel_slot_y(inventory_height)
      input_slot_y(inventory_height) + Margin + SlotSize
    end

    def draw_struct_info(inventory_width, inventory_height)
      dx = hud_x
      dy = hud_y(inventory_height) + Margin

      # background
      LibAllegro.draw_filled_rectangle(dx, dy, dx + inventory_width - Margin, dy + inventory_height - Margin * 2, BackgroundColor)

      # input slot
      is_x = input_slot_x
      is_y = input_slot_y(inventory_height)
      InventoryHUD.draw_slot(is_x, is_y, input_item, input_slot_hover?)

      # output progress
      os_x = output_slot_x(inventory_width)
      px = is_x + SlotSize + Margin
      py = is_y + Margin * 3
      progress_total_x = os_x - Margin
      progress_width = progress_total_x - px
      progress_end_x = px + progress_width * output_timer.percent
      LibAllegro.draw_filled_rectangle(px, py, progress_end_x, py - Margin * 3 + SlotSize - Margin * 3, OutputProgressColor)

      # output slot
      InventoryHUD.draw_slot(os_x, output_slot_y(inventory_height), output_item, output_slot_hover?)

      # fuel slot
      InventoryHUD.draw_slot(fuel_slot_x, fuel_slot_y(inventory_height), fuel_item, fuel_slot_hover?)

      # info text at bottom
      HUDText.new("#{name}").draw_from_bottom(dx + Margin, dy + inventory_height - Margin)
    end
  end
end
