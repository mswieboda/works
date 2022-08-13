require "./item/base"
require "./hud_text"

module Works
  class Inventory
    MaxSlots = 10

    getter? shown
    getter items
    getter max_slots

    def initialize
      @shown = false
      @max_slots = MaxSlots
      @items = [] of Item::Base
    end

    def amount_can_add(item_klass, amount : Int)
      added = 0
      leftovers = amount
      temp_items = items.dup

      while leftovers > 0
        if item = temp_items.reject(&.full?).find { |i| i.key == item_klass.key }
          added += leftovers
          leftovers = item.add(leftovers)
        else
          if temp_items.size >= max_slots
            return added
          end

          item = item_klass.new
          added = leftovers
          leftovers = item.add(leftovers)
          temp_items << item
        end
      end

      added
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
          @items << item
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
      if shown?
        hide
      else
        print
        show
      end
    end

    def print_str
      str = "> Player Inventory:\n"

      items.each do |item|
        str += "> #{item.print_str}\n"
      end

      str.chomp
    end

    def print
      puts print_str
    end

    def draw(x, y)
      return unless shown?

      print_str.split("\n").each do |str|
        HUDText.new(str).draw_from_left(x, y)
        y += 10
      end
    end
  end
end
