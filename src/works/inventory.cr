require "./item/base"
require "./hud_text"

module Works
  class Inventory
    MaxSlots = 60
    SortOrder = [
      Item::Ore::Coal.key, Item::Ore::Copper.key, Item::Ore::Iron.key, Item::Ore::Stone.key
    ]

    module HUD
      BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.13)
      SlotBackgroundColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.13)
      SlotBorderColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.03)
      SlotSize = 32
      SlotMargin = 4
      SlotCols = (MaxSlots / 5).to_i
    end

    getter? shown
    getter items
    getter max_slots

    def initialize
      @shown = false
      @max_slots = MaxSlots
      @items = [] of Item::Base
    end

    def amount_can_add(item_klass, amount : Int)
      leftovers = amount
      temp_items = items.clone

      while leftovers > 0
        if item = temp_items.reject(&.full?).find { |i| i.key == item_klass.key }
          leftovers = item.add(leftovers)
        else
          break if temp_items.size >= max_slots

          item = item_klass.new
          leftovers = item.add(leftovers)
          temp_items << item
        end
      end

      temp_items.clear

      amount - leftovers
    end

    def add(item_klass, amount : Int)
      leftovers = amount

      while leftovers > 0
        if item = items.reject(&.full?).find { |i| i.key == item_klass.key }
          leftovers = item.add(leftovers)
        else
          if items.size >= max_slots
            puts "> Inventory#add reached max_slots"
            return
          end

          item = item_klass.new
          leftovers = item.add(leftovers)

          add_item_and_sort!(item)
        end
      end
    end

    private def add_item_and_sort!(item : Item::Base)
      @items << item
      sort_items
    end

    def sort_items
      # TODO: also sort by `amount` if keys are the same
      @items.sort! { |a, b| (SortOrder.index(a.key) || 0) <=> (SortOrder.index(b.key) || 0) }
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

    def print_str
      str = "Player Inventory:\n"

      items.each do |item|
        str += "#{item.print_str}\n"
      end

      str.chomp
    end

    def draw(x, y)
      return unless shown?

      cols = HUD::SlotCols
      rows = (max_slots / cols).ceil.to_i
      width = HUD::SlotMargin + cols * HUD::SlotSize + HUD::SlotMargin
      height = HUD::SlotMargin + rows * HUD::SlotSize + HUD::SlotMargin
      dx = Screen::Width / 2 - width / 2
      dy = Screen::Height / 2 - height / 2

      draw_background(dx, dy, width, height)
      draw_slots(dx, dy, cols, rows)
    end

    def draw_background(x, y, width, height)
      LibAllegro.draw_filled_rectangle(x, y, x + width, y + height, HUD::BackgroundColor)
    end

    def draw_slots(x, y, cols, rows)
      index = 0
      cols = [cols, max_slots].min

      rows.times do |row|
        cols.times do |col|
          dx = x + HUD::SlotMargin + col * HUD::SlotSize
          dy = y + HUD::SlotMargin + row * HUD::SlotSize
          LibAllegro.draw_filled_rectangle(
            dx,
            dy,
            dx + HUD::SlotSize,
            dy + HUD::SlotSize,
            HUD::SlotBackgroundColor
          )

          if index < items.size
            item = items[index]
            item.draw(dx + HUD::SlotMargin, dy + HUD::SlotMargin, HUD::SlotSize - HUD::SlotMargin * 2)
          end

          LibAllegro.draw_rectangle(dx, dy, dx + HUD::SlotSize, dy + HUD::SlotSize, HUD::SlotBorderColor, 1)

          index += 1
        end
      end
    end
  end
end
