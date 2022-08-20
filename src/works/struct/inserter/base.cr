require "../base"

module Works::Struct::Inserter
  abstract class Base < Struct::Base
    Key = :inserter
    Name = "inserter"
    Color = LibAllegro.map_rgb_f(1, 0, 1)

    # HUD
    Margin = 4 * Screen::ScaleFactor
    SlotSize = 32 * Screen::ScaleFactor
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)

    property item : Item::Base | Nil
    getter? item_slot_hover

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @item = nil
      @item_slot_hover = false
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

    def item_class
      case key
      when :burner_inserter
        Item::Struct::Inserter::Burner
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def accept_item?(item : Item::Base)
      true
    end

    def item_grab_size
      1
    end

    def update

    end

    # HUD

    def update_struct_info_slot_hovers(mouse, inventory_width, inventory_height)
      if hud_shown?
        @item_slot_hover = slot_hover?(item_slot_x, item_slot_y(inventory_height), mouse)
      end
    end

    def hud_x
      Screen::Width / 2
    end

    def hud_y(inventory_height)
      Screen::Height / 2 - inventory_height / 2
    end

    def item_slot_x
      hud_x + Margin
    end

    def item_slot_y(inventory_height)
      hud_y(inventory_height) + Margin + Margin
    end

    def draw_struct_info(inventory_width, inventory_height)
      dx = hud_x
      dy = hud_y(inventory_height) + Margin

      # background
      LibAllegro.draw_filled_rectangle(dx, dy, dx + inventory_width - Margin, dy + inventory_height - Margin * 2, BackgroundColor)

      # item slot
      InventoryHUD.draw_slot(item_slot_x, item_slot_y(inventory_height), item, item_slot_hover?)

      # info text at bottom
      HUDText.new("#{name}").draw_from_bottom(dx + Margin, dy + inventory_height - Margin)
    end
  end
end
