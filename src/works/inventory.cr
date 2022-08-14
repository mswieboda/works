require "./item/base"
require "./inventory_hud"
require "./item/struct/stone_furnace"
require "./hud_text"

module Works
  class Inventory
    MaxSlots = 60
    SortOrder = [
      # ore
      Item::Ore::Coal, Item::Ore::Copper, Item::Ore::Iron, Item::Ore::Stone,
      # struct
      Item::Struct::StoneFurnace
    ].map(&.key)

    getter items
    getter max_slots
    getter hud

    delegate shown?, to: @hud
    delegate hover?, to: @hud

    def initialize
      @max_slots = MaxSlots
      @items = [] of Item::Base
      @hud = InventoryHUD.new(@items, @max_slots)
    end

    def init
      add(Item::Struct::StoneFurnace, 1)
    end

    def update(keys : Keys, mouse : Mouse, x, y)
      hud.update(keys, mouse, x, y)
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

    def print_str
      str = "Player Inventory:\n"

      items.each do |item|
        str += "#{item.print_str}\n"
      end

      str.chomp
    end

    def draw(x, y)
      hud.draw(x, y)
    end
  end
end
