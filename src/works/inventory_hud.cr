require "./item/base"
require "./keys"
require "./mouse"

module Works
  class InventoryHUD
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)
    Margin = 4 * Screen.scale_factor
    SlotBackgroundColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.13)
    SlotBorderColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.03)
    SlotCols = 10
    SlotSize = 32 * Screen.scale_factor

    getter? shown
    getter? hover
    getter items
    getter max_slots : Int32
    getter hover_index : Int32 | Nil

    def initialize(items : Array(Item::Base), max_slots)
      @shown = false
      @hover = false
      @items = items
      @max_slots = max_slots
      @hover_index = nil
    end

    def update(keys : Keys, mouse : Mouse)
      if shown?
        update_hover(mouse)
        update_hover_index(mouse)
      end
    end

    def update_hover(mouse : Mouse)
      @hover = hover?(mouse)
    end

    def update_hover_index(mouse : Mouse)
      @hover_index = nil

      return unless hover?

      max_slots.times do |index|
        if mouse.hover?(item_x(item_col(index)), item_y(item_row(index)), SlotSize, SlotSize)
          @hover_index = index
        end
      end
    end

    def show
      @shown = true
    end

    def hide
      @shown = false
    end

    def show_toggle
      shown? ? hide : show
    end

    def item_cols
      cols = SlotCols

      [cols, max_slots].min
    end

    def item_rows
      (max_slots / item_cols).ceil.to_i
    end

    def item_col(index)
      index % item_cols
    end

    def item_row(index)
      (index / item_cols).to_i % item_rows
    end

    def inventory_width
      Margin + item_cols * SlotSize
    end

    def width
      inventory_width + inventory_width + Margin
    end

    def height
      Margin + item_rows * SlotSize + Margin
    end

    def x
      Screen.width / 2 - inventory_width
    end

    def y
      Screen.height / 2 - height / 2
    end

    def item_x(col)
      x + Margin + col * SlotSize
    end

    def item_y(row)
      y + Margin + row * SlotSize
    end

    def self.item_size
      SlotSize - Margin * 2
    end

    def item_size
      self.class.item_size
    end

    def hover?(mouse : Mouse)
      return false unless shown?

      mouse.hover?(x, y, width, height)
    end

    def draw
      return unless shown?

      draw_background
      draw_slots
    end

    def draw_background
      LibAllegro.draw_filled_rectangle(x, y, x + width, y + height, BackgroundColor)
    end

    def draw_slots
      index = 0

      item_rows.times do |row|
        item_cols.times do |col|
          dx = item_x(col)
          dy = item_y(row)
          item = index < items.size ? items[index] : nil

          draw_slot(dx, dy, item, index == hover_index)

          index += 1
        end
      end
    end

    def draw_slot(dx, dy, item : Item::Base | Nil, hovering = false)
      self.class.draw_slot(dx, dy, item, hovering)
    end

    def self.draw_slot(dx, dy, item : Item::Base | Nil, hovering = false)
      LibAllegro.draw_filled_rectangle(
        dx,
        dy,
        dx + SlotSize,
        dy + SlotSize,
        SlotBackgroundColor
      )

      if hovering
        LibAllegro.draw_filled_rectangle(dx, dy, dx + SlotSize, dy + SlotSize, HoverColor)
      end

      if item
        item.draw_icon(dx + Margin, dy + Margin, item_size)
      end

      LibAllegro.draw_rectangle(dx, dy, dx + SlotSize, dy + SlotSize, SlotBorderColor, 1)
    end
  end
end
