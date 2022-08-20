require "../cell"

module Works::Struct
  abstract class Base < Cell
    Key = :struct
    Name = "Struct"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    # HUD
    SlotSize = 32 * Screen::ScaleFactor

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

    abstract def update(map : Map)

    def grab_item
      nil
    end

    abstract def grab_item(item_grab_size)

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

    def draw(x, y)
      draw(x, y, color)
    end

    def draw(dx, dy, color)
      dx += x
      dy += y

      LibAllegro.draw_filled_rectangle(dx, dy, dx + width, dy + height, color)
    end

    def draw_hover_info
      HUDText.new("#{name}").draw_from_bottom(0, Screen::Height)
    end

    def draw_struct_info(inventory_width, inventory_height)
    end

    def destroy
    end
  end
end
