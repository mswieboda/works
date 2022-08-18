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
    getter? input_slot_hover
    getter? output_slot_hover
    getter? fuel_slot_hover
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
      @input_slot_hover = false
      @output_slot_hover = false
      @fuel_slot_hover = false
    end

    def update(keys : Keys, mouse : Mouse)
      update_hover(mouse)
      update_hover_index(mouse)
      update_struct_info_slot_hovers(mouse)

      if keys.just_pressed?(LibAllegro::KeyE)
        show_toggle
      elsif keys.just_pressed?(LibAllegro::KeyEscape)
        hide
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

    def update_struct_info_slot_hovers(mouse : Mouse)
      @input_slot_hover = slot_hover?(input_slot_x, input_slot_y, mouse)
      @output_slot_hover = slot_hover?(output_slot_x, output_slot_y,mouse)
      @fuel_slot_hover = slot_hover?(fuel_slot_x, fuel_slot_y,mouse)
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

    def input_slot_x
      x + inventory_width + Margin
    end

    def input_slot_y
      y + Margin + Margin
    end

    def output_slot_x
      input_slot_x + struct_info_width - Margin - SlotSize - Margin
    end

    def output_slot_y
      input_slot_y
    end

    def fuel_slot_x
      input_slot_x
    end

    def fuel_slot_y
      input_slot_y + Margin + SlotSize
    end

    def hover?(mouse : Mouse)
      return false unless shown?

      mouse.x >= x && mouse.x < x + width &&
        mouse.y > y && mouse.y < y + height
    end

    def slot_hover?(slot_x, slot_y, mouse : Mouse)
      return false unless hover? && show_struct

      mouse.x >= slot_x && mouse.x < slot_x + SlotSize &&
        mouse.y > slot_y && mouse.y < slot_y + SlotSize
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

        # input slot
        draw_slot(input_slot_x, input_slot_y, nil, input_slot_hover?)

        # output slot
        draw_slot(output_slot_x, output_slot_y, nil, output_slot_hover?)

        # fuel slot
        draw_slot(fuel_slot_x, fuel_slot_y, nil, fuel_slot_hover?)

        # info text at bottom
        HUDText.new("#{strct.name}").draw_from_bottom(dx + Margin, y + height - Margin)
      end
    end
  end
end
