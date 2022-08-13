require "./item/base"

module Works
  class Inventory
    MaxSlots = 10

    getter items
    getter max_slots

    def initialize
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

    def print
      puts "> Player Inventory:"

      items.each do |item|
        print "> "
        item.print
        puts
      end
    end

    def draw
    end
  end
end
