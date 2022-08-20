require "./base"

module Works::Struct::Furnace
  class Stone < Base
    Key = :stone_furnace
    Name = "Stone furnace"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    property fuel_item : Item::Base | Nil
    getter? fuel_slot_hover

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @fuel_item = nil
      @fuel_slot_hover = false
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

    def output_duration(item : Item::Base) : Time::Span
      case item
      when Item::Ore::Copper, Item::Ore::Iron, Item::Ore::Stone
        3.2.seconds
      when Item::IronPlate
        16.seconds
      else
        0.seconds
      end
    end

    def accept_fuel?(item : Item::Base)
      case item
      when Item::Ore::Coal
        true
      else
        false
      end
    end

    # HUD

    def update_struct_info_slot_hovers(mouse, inventory_width, inventory_height)
      super(mouse, inventory_width, inventory_height)

      if hud_shown?
        @fuel_slot_hover = slot_hover?(fuel_slot_x, fuel_slot_y(inventory_height), mouse)
      end
    end

    def fuel_slot_x
      input_slot_x
    end

    def fuel_slot_y(inventory_height)
      input_slot_y(inventory_height) + Margin + SlotSize
    end

    def draw_struct_info(inventory_width, inventory_height)
      super(inventory_width, inventory_height)

      # fuel slot
      InventoryHUD.draw_slot(fuel_slot_x, fuel_slot_y(inventory_height), fuel_item, fuel_slot_hover?)
    end
  end
end
