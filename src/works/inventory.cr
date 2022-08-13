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

    def add(item_klass, amount : Int)
      leftovers = amount

      while leftovers > 0
        if items.size >= max_slots
          puts "> Inventory::add reached max_slots, TODO: drop extra items on ground"
          return
        end

        item = item_klass.new
        leftovers = item.add(leftovers)
        @items << item
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
