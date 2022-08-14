require "./item/base"
require "./item/held"
require "./item/hand"
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
    getter held_item : Item::Held | Nil
    getter held_index : Int32 | Nil

    delegate shown?, to: @hud
    delegate hover?, to: @hud

    def initialize
      @max_slots = MaxSlots
      @items = [] of Item::Base
      @hud = InventoryHUD.new(@items, @max_slots)
      @held_item = nil
      @held_index = nil
    end

    def init
      add(Item::Struct::StoneFurnace, 1)
    end

    def update(keys : Keys, mouse : Mouse, map : Map, player : Player)
      hud.update(keys, mouse, map.x, map.y)

      if shown? && !held_item && keys.just_pressed?(LibAllegro::KeyQ)
        hud.hide
      else
        update_held_item(keys, mouse, map, player)
      end
    end

    def update_held_item(keys : Keys, mouse : Mouse, map : Map, player : Player)
      if held_item = @held_item
        held_item.update(mouse, map, player)

        if held_index = @held_index
          if keys.just_pressed?(LibAllegro::KeyQ)
            put_held_item_back(held_item, held_index)
            return
          end

          return unless mouse.left_just_pressed?

          if hud.hover?
            put_held_item_back(held_item, held_index)
          else
            if held_item.buildable? && held_item.item.amount > 0
              if strct = held_item.strct
                map.structs << strct.clone
                held_item.item.remove(1)
              end

              if held_item.item.amount <= 0
                if hand_item = items.delete(items[held_index])
                  @held_index = nil
                  @held_item = nil
                end
              end
            end
          end
        end
      else
        if hover_index = hud.hover_index
          if mouse.left_pressed?
            if item = items.delete(items[hover_index])
              # TODO: should show struct when hovering over map, and item hovering over inventory
              @held_item = Item::Held.new(mouse.x, mouse.y, item, hud.item_size)

              if item.is_a?(Item::Struct::Base)
                if held_item = @held_item
                  held_item.strct = item.to_struct
                end
              end

              @held_index = hover_index

              items.insert(hover_index, Item::Hand.new)
            end
          end
        end
      end
    end

    def put_held_item_back(held_item, held_index)
      if hand_item = items.delete(items[held_index])
        item = held_item.item

        items.insert(held_index, item)

        @held_index = nil
        @held_item = nil
      end
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

    def draw
      hud.draw
    end
  end
end
