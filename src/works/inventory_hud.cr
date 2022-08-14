require "./item/base"
require "./item/held"
require "./item/holding"
require "./keys"
require "./mouse"

module Works
  class InventoryHUD
    module HUD
      BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
      SlotBackgroundColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.13)
      SlotBorderColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.03)
      SlotSize = 32
      SlotMargin = 4
    end

    getter? shown
    getter items
    getter max_slots : Int32
    getter hover_index : Int32 | Nil
    getter held_item : Item::Held | Nil
    getter held_index : Int32 | Nil

    def initialize(items : Array(Item::Base), max_slots)
      @shown = false
      @items = items
      @max_slots = max_slots
      @hover_index = nil
      @held_item = nil
      @held_index = nil
    end

    def update(keys : Keys, mouse : Mouse, x, y)
      update_items(mouse, x, y) if shown?

      if keys.just_pressed?(LibAllegro::KeyI)
        show_toggle
      end
    end

    def update_items(mouse : Mouse, x, y)
      mouse_x, mouse_y = mouse.to_xy(x, y)
      @hover_index = nil

      items.each_index do |index|
        item_x = x(col(index))
        item_y = y(row(index))

        if mouse_x >= item_x && mouse_x < item_x + HUD::SlotSize &&
           mouse_y >= item_y && mouse_y < item_y + HUD::SlotSize
          @hover_index = index
        end
      end

      if held_item = @held_item
        if mouse.left_pressed?
          held_item.update(mouse)
        else
          if held_index = @held_index
            if holding_item = items.delete(items[held_index])
              item = held_item.item

              items.insert(held_index, item)

              @held_index = nil
              @held_item = nil
            end
          end
        end
      else
        if hover_index = @hover_index
          if mouse.left_pressed?
            if item = items.delete(items[hover_index])
              @held_item = Item::Held.new(mouse.x, mouse.y, item, item_size)
              @held_index = hover_index

              items.insert(hover_index, Item::Holding.new)
            end
          end
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

    def width
      HUD::SlotMargin + cols * HUD::SlotSize + HUD::SlotMargin
    end

    def height
      HUD::SlotMargin + rows * HUD::SlotSize + HUD::SlotMargin
    end

    def x
      Screen::Width / 2 - width / 2
    end

    def y
      Screen::Height / 2 - height / 2
    end

    def x(col)
      x + HUD::SlotMargin + col * HUD::SlotSize
    end

    def y(row)
      y + HUD::SlotMargin + row * HUD::SlotSize
    end

    def item_size
      HUD::SlotSize - HUD::SlotMargin * 2
    end

    def hover?(mouse : Mouse)
      mouse.x >= x && mouse.x < x + width &&
        mouse.y > y && mouse.y < y + height
    end

    def draw
      return unless shown?

      draw_background
      draw_slots
      draw_held_item
    end

    def draw_background
      LibAllegro.draw_filled_rectangle(x, y, x + width, y + height, HUD::BackgroundColor)
    end

    def draw_slots
      index = 0

      rows.times do |row|
        cols.times do |col|
          dx = x(col)
          dy = y(row)

          LibAllegro.draw_filled_rectangle(
            dx,
            dy,
            dx + HUD::SlotSize,
            dy + HUD::SlotSize,
            HUD::SlotBackgroundColor
          )

          if index < items.size
            item = items[index]
            item.draw(dx + HUD::SlotMargin, dy + HUD::SlotMargin, item_size)

            if index == hover_index
              LibAllegro.draw_rectangle(dx, dy, dx + HUD::SlotSize, dy + HUD::SlotSize, LibAllegro.map_rgb_f(1, 1, 1), 1)
            end
          end

          LibAllegro.draw_rectangle(dx, dy, dx + HUD::SlotSize, dy + HUD::SlotSize, HUD::SlotBorderColor, 1)

          index += 1
        end
      end
    end

    def draw_held_item
      if held_item = @held_item
        held_item.draw
      end
    end
  end
end