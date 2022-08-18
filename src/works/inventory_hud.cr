require "./item/base"
require "./keys"
require "./mouse"

module Works
  class InventoryHUD
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
    HoverColor = LibAllegro.premul_rgba_f(1, 0.5, 0, 0.33)
    Margin = 4
    SlotBackgroundColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.13)
    SlotBorderColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.03)
    SlotSize = 32
    StructInfoSize = 192

    getter? shown
    getter? hover
    getter items
    getter max_slots : Int32
    getter hover_index : Int32 | Nil
    getter show_struct : Struct::Base | Nil

    def initialize(items : Array(Item::Base), max_slots)
      @shown = false
      @hover = false
      @items = items
      @max_slots = max_slots
      @hover_index = nil
      @show_struct = nil
    end

    def update(keys : Keys, mouse : Mouse)
      @hover_index = nil

      update_hover(mouse)
      update_hover_index(mouse) if hover?

      if keys.just_pressed?(LibAllegro::KeyE)
        show_toggle
      elsif keys.just_pressed?(LibAllegro::KeyEscape)
        hide
      end
    end

    def update_hover(mouse : Mouse)
      @hover = shown? && hover?(mouse)
    end

    def update_hover_index(mouse : Mouse)
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
      if shown? && show_struct
        @show_struct = nil
      end

      @shown = false
    end

    def show_toggle
      shown? ? hide : show
    end

    def show_struct(strct : Struct::Base)
      @show_struct = strct

      show
    end

    def cols
      cols = (max_slots / 5).to_i

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

    def struct_info_width
      StructInfoSize
    end

    def width
      width = inventory_width
      width += struct_info_width if show_struct
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

    def item_size
      SlotSize - Margin * 2
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
      draw_struct_info if show_struct
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
        item.draw(dx + Margin, dy + Margin, item_size)
      end

      LibAllegro.draw_rectangle(dx, dy, dx + SlotSize, dy + SlotSize, SlotBorderColor, 1)
    end

    def draw_struct_info
      if strct = @show_struct
        dx = x + inventory_width
        dy = y + Margin

        # background
        LibAllegro.draw_filled_rectangle(dx, dy, dx + struct_info_width - Margin, dy + height - Margin * 2, BackgroundColor)

        dx += Margin
        dy += Margin

        HUDText.new("#{strct.name}").draw_from_bottom(dx, y + height - Margin)

        # input slot
        draw_slot(dx, dy, nil, false)

        # output slot
        draw_slot(dx + struct_info_width - Margin - SlotSize - Margin, dy, nil, false)

        # fuel slot
        draw_slot(dx, dy + Margin + SlotSize, nil, false)
      end
    end
  end
end
