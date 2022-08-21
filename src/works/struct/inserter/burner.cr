require "./base"

module Works::Struct::Inserter
  class Burner < Base
    Key = :burner_inserter
    Name = "Burner inserter"
    Color = LibAllegro.map_rgb_f(0.333, 0.25, 0.21)
    RotationSpeed = 216 # degrees per second

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

    def self.rotation_speed
      RotationSpeed
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

    def slot_click_held_item(inventory : Inventory, held_item : Item::Held)
      super(inventory, held_item)

      if fuel_slot_hover? && accept_fuel?(held_item.item)
        if item = fuel_item
          @fuel_item = inventory.swap_held_item(held_item, item)
        elsif item = inventory.remove_held_item
          @fuel_item = item
        end
      end
    end

    def slot_click_grab_item(inventory : Inventory, mouse : Mouse)
      super(inventory, mouse)

      if fuel_slot_hover? && (item = fuel_item)
        inventory.grab_slot_item(item, mouse)
        @fuel_item = nil
      end
    end

    def fuel_slot_x
      hud_x + Margin
    end

    def fuel_slot_y(inventory_height)
      item_slot_y(inventory_height) + Margin + SlotSize
    end

    def draw_struct_info(inventory_width, inventory_height)
      super(inventory_width, inventory_height)

      # fuel slot
      InventoryHUD.draw_slot(fuel_slot_x, fuel_slot_y(inventory_height), fuel_item, fuel_slot_hover?)
    end
  end
end
