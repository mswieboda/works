require "./item/base"
require "./item/held"
require "./item/hand"
require "./item/**"
require "./inventory_hud"

module Works
  class Inventory
    MaxSlots = 80
    SortOrder = [
      # ore
      Item::Ore::Coal, Item::Ore::Copper, Item::Ore::Iron, Item::Ore::Stone,
      # plates
      Item::Plate::Copper, Item::Plate::Iron, Item::Plate::Steel,
      # other
      Item::StoneBrick,
      # transport belts
      Item::Struct::TransportBelt::Base, Item::Struct::TransportBelt::Fast, Item::Struct::TransportBelt::Express,
      # inserters
      Item::Struct::Inserter::Burner, Item::Struct::Inserter::Inserter,
      # chests
      Item::Struct::Chest::Wooden, Item::Struct::Chest::Iron, Item::Struct::Chest::Steel,
      # furnaces
      Item::Struct::Furnace::Stone, Item::Struct::Furnace::Electric
    ].map(&.key)

    getter items
    getter max_slots
    getter hud
    getter held_item : Item::Held | Nil
    getter held_index : Int32 | Nil

    delegate shown?, to: @hud
    delegate hover?, to: @hud
    delegate show_struct, to: @hud
    delegate show_toggle, to: @hud
    delegate show, to: @hud
    delegate hide, to: @hud

    def initialize
      @max_slots = MaxSlots
      @items = [] of Item::Base
      @hud = InventoryHUD.new(@items, @max_slots)
      @held_item = nil
      @held_index = nil
    end

    def init
      add(Item::Struct::Furnace::Stone, 3)
      add(Item::Struct::Furnace::Electric, 1)
      add(Item::Struct::Inserter::Burner, 5)
      add(Item::Struct::Inserter::Inserter, 5)
      add(Item::Struct::TransportBelt::Base, 15)
      add(Item::Struct::TransportBelt::Fast, 15)
      add(Item::Struct::TransportBelt::Express, 15)
      add(Item::Struct::Chest::Wooden, 3)
      add(Item::Struct::Chest::Iron, 3)
      add(Item::Struct::Chest::Steel, 3)
    end

    def update(keys : Keys, mouse : Mouse, map : Map, player : Player)
      hud.update(keys, mouse)

      if keys.just_pressed?(LibAllegro::KeyQ) && !held_item && (strct = map.get_struct(mouse))
        key = strct.item_class.key

        if index = items.index { |i| i.key == key }
          grab_inventory_item(index, mouse)
        end
      else
        update_held_item(keys, mouse, map, player)
      end
    end

    def update_held_item(keys : Keys, mouse : Mouse, map : Map, player : Player)
      if held_item = @held_item
        held_item.update(mouse, map, player)

        if keys.just_pressed?(LibAllegro::KeyQ)
          if held_index = @held_index
            put_held_item_back(held_item, held_index)
          else
            add_held_item_to_inventory(held_item.item)
          end

          return
        end

        return unless mouse.left_just_pressed?

        if held_index = @held_index
          if !(hud.shown? && hud.hover?) && held_item.buildable? && held_item.item.amount > 0
            if strct = held_item.strct
              map.structs << strct.clone
              held_item.item.remove(1)
            end

            if held_item.item.amount <= 0
              remove_held_item
            end
          elsif hud.shown? && hud.hover_index
            put_held_item_back(held_item, held_index)
          end
        elsif hud.shown? && hud.hover_index
          add_held_item_to_inventory(held_item.item)
        end
      elsif mouse.left_just_pressed?
        if hover_index = hud.hover_index
          if hover_index <= items.size - 1
            grab_inventory_item(hover_index, mouse)
          end
        end
      end
    end

    def put_held_item_back(held_item, held_index)
      if hand_item = items.delete(items[held_index])
        item = held_item.item

        add(item.class, item.amount)

        @held_index = nil
        @held_item = nil
      end
    end

    def add_held_item_to_inventory(item)
      add(item.class, item.amount)

      @held_index = nil
      @held_item = nil
    end

    def grab_inventory_item(index, mouse : Mouse)
      if item = items.delete(items[index])
        grab_slot_item(item, mouse)

        @held_index = index

        items.insert(index, Item::Hand.new)
      end
    end

    def grab_slot_item(item, mouse : Mouse)
      @held_item = Item::Held.new(mouse.x, mouse.y, item, hud.item_size)

      if item.is_a?(Item::Struct::Base)
        if held_item = @held_item
          held_item.strct = item.to_struct
        end
      end
    end

    def remove_held_item
      if held_item = @held_item
        @held_item = nil

        if held_index = @held_index
          remove_hand_item(held_index)
        end

        return held_item.item
      end
    end

    def remove_hand_item(held_index)
      if hand_item = items.delete(items[held_index])
        @held_index = nil
      end
    end

    def swap_held_item(held_item : Item::Held, item : Item::Base)
      swap_item = held_item.item
      held_item.item = item

      if item.is_a?(Item::Struct::Base)
        held_item.strct = item.to_struct
      else
        held_item.strct = nil
      end

      return swap_item
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
      @items.sort! do |a, b|
        # sort by key
        sort = (SortOrder.index(a.key) || 0) <=> (SortOrder.index(b.key) || 0)
        # than by amount (descending)
        sort = b.amount <=> a.amount if sort == 0
        sort
      end
    end

    def print_str
      str = "Player Inventory:\n"

      items.each do |item|
        str += "#{item.print_str}\n"
      end

      str.chomp
    end

    def draw
      hud.draw
    end
  end
end
