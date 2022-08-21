require "../cell"

module Works::Struct
  abstract class Base < Cell
    Key = :struct
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    # HUD
    Margin = 4 * Screen::ScaleFactor
    SlotSize = 32 * Screen::ScaleFactor
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

    def input_item
      nil
    end

    def add_input?(item)
      false
    end

    def add_input(klass, amount)
      amount
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
      HUDText.new("#{name}").draw_from_bottom(0, Screen::Height)
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

    def update_struct_info_slot_hovers(mouse : Mouse, inventory_width,  inventory_height)
    end

    def slot_hover?(slot_x, slot_y, mouse : Mouse)
      mouse.x >= slot_x && mouse.x < slot_x + SlotSize &&
        mouse.y > slot_y && mouse.y < slot_y + SlotSize
    end

    def show_hud
      @hud_shown = true
    end

    def hide_hud
      @hud_shown = false
    end

    def hud_x
      Screen::Width / 2 + hud_margin
    end

    def hud_y(inventory_height)
      Screen::Height / 2 - inventory_height / 2
    end

    def draw_struct_info(inventory_width, inventory_height)
      dx = hud_x
      dy = hud_y(inventory_height) + hud_margin

      # background
      LibAllegro.draw_filled_rectangle(dx, dy, dx + inventory_width - hud_margin, dy + inventory_height - hud_margin * 2, hud_background_color)

      draw_struct_info_slots(inventory_width, inventory_height)

      # info text at bottom
      HUDText.new("#{name}").draw_from_bottom(dx + Margin, dy + inventory_height - Margin - Margin)
    end

    def draw_struct_info_slots(inventory_width, inventory_height)
    end
  end
end
