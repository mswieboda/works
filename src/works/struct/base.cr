require "../cell"

module Works::Struct
  abstract class Base < Cell
    Key = :struct
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    # HUD
    Margin = 4 * Screen.scale_factor
    SlotSize = 32 * Screen.scale_factor
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)

    getter? hud_shown

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @hud_shown = false
    end

    def self.key
      Key
    end

    def key
      self.class.key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def color
      self.class.color
    end

    abstract def item_class

    def accept_item?(item : Item::Base)
      true
    end

    abstract def update(map : Map)

    def grab_item
      nil
    end

    abstract def grab_item(item_grab_size)

    def add_from_inserter?(item : Item::Base, inserter_facing : Symbol)
      false
    end

    def add_from_inserter(klass, amount, inserter_facing : Symbol)
      amount
    end

    def rotate
    end

    def after_rotate(map : Map)
    end

    def can_overwrite?(strct : Struct::Base)
      false
    end

    def overlaps_input?(col, row)
      overlaps?(col, row)
    end

    def overlaps_output?(col, row)
      overlaps?(col, row)
    end

    def draw(x, y)
      draw(x, y, color)
    end

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def destroy
    end

    def draw_hover_info
      HUDText.new("#{name}").draw_from_bottom(0, Screen.height)
    end

    # HUD

    def self.hud_margin
      Margin
    end

    def hud_margin
      self.class.hud_margin
    end

    def self.hud_slot_size
      SlotSize
    end

    def hud_slot_size
      self.class.hud_slot_size
    end

    def self.hud_background_color
      BackgroundColor
    end

    def hud_background_color
      self.class.hud_background_color
    end

    def self.hud_hover_color
      HoverColor
    end

    def hud_hover_color
      self.class.hud_background_color
    end

    def show_hud
      @hud_shown = true
    end

    def hide_hud
      @hud_shown = false
    end

    def update_struct_info_slot_hovers(mouse : Mouse, inventory_width,  inventory_height)
    end

    def slot_hover?(slot_x, slot_y, mouse : Mouse)
      mouse.hover?(slot_x, slot_y, hud_slot_size, hud_slot_size)
    end

    def slot_click(inventory : Inventory, mouse : Mouse)
      if held_item = inventory.held_item
        slot_click_held_item(inventory, held_item)
      else
        slot_click_grab_item(inventory, mouse)
      end
    end

    def slot_click_held_item(inventory : Inventory, held_item : Item::Held)
    end

    def slot_click_grab_item(inventory : Inventory, mouse : Mouse)
    end

    def hud_x
      Screen.width / 2 + hud_margin
    end

    def hud_y(inventory_height)
      Screen.height / 2 - inventory_height / 2
    end

    def draw_struct_info(inventory_width, inventory_height)
      dx = hud_x
      dy = hud_y(inventory_height) + hud_margin

      # background
      LibAllegro.draw_filled_rectangle(dx, dy, dx + inventory_width - hud_margin, dy + inventory_height - hud_margin * 2, hud_background_color)

      draw_struct_info_slots(inventory_width, inventory_height)

      # info text at bottom
      HUDText.new("#{name}").draw_from_bottom(dx + hud_margin, dy + inventory_height - hud_margin - hud_margin)
    end

    def draw_struct_info_slots(inventory_width, inventory_height)
    end
  end
end
