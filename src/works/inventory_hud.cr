require "./item/base"
require "./keys"
require "./mouse"

module Works
  class InventoryHUD
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)
    Margin = 4 * Screen::ScaleFactor
    SlotBackgroundColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.13)
    SlotBorderColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.03)
    SlotCols = 10
    SlotSize = 32 * Screen::ScaleFactor

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
        item_x = x(col(index))
        item_y = y(row(index))

        if mouse.x >= item_x && mouse.x < item_x + SlotSize &&
           mouse.y >= item_y && mouse.y < item_y + SlotSize
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

    def cols
      cols = SlotCols

      [cols, max_slots].min
    end

    def rows
      (max_slots / cols).ceil.to_i
    end

    def col(index)
      index % cols
    end

    def row(index)
      (index / cols).to_i % rows
    end

    def inventory_width
      Margin + cols * SlotSize + Margin
    end

    def width
      width = inventory_width
      width += inventory_width - Margin
      width
    end

    def height
      Margin + rows * SlotSize + Margin
    end

    def x
      Screen::Width / 2 - width / 2
    end

    def y
      Screen::Height / 2 - height / 2
    end

    def x(col)
      x + Margin + col * SlotSize
    end

    def y(row)
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

      mouse.x >= x && mouse.x < x + width &&
        mouse.y > y && mouse.y < y + height
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

      rows.times do |row|
        cols.times do |col|
          dx = x(col)
          dy = y(row)

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
