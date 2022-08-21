require "../base"

module Works::Struct::Chest
  abstract class Base < Struct::Base
    Key = :chest_base
    Name = "Chest base"
    Color = LibAllegro.map_rgb_f(1, 0, 1)
    Storage = 1

    # HUD
    SlotCols = 10

    getter items : Array(Item::Base | Nil)
    getter hover_index : Int32 | Nil

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @items = Array(Item::Base | Nil).new(storage, nil)
      @hover_index = nil
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.storage
      Storage
    end

    def storage
      self.class.storage
    end

    def item_class
      case key
      when :wooden_chest
        Item::Struct::Chest::Wooden
      when :iron_chest
        Item::Struct::Chest::Iron
      when :steel_chest
        Item::Struct::Chest::Steel
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def update(map : Map)

    end

    def grab_item(item_grab_size)
      # TODO: implement
    end

    # HUD
    def item_cols
      cols = SlotCols

      [cols, storage].min
    end

    def item_rows
      (storage / item_cols).ceil.to_i
    end

    def item_col(index)
      index % item_cols
    end

    def item_row(index)
      (index / item_cols).to_i % item_rows
    end

    def item_x(col)
      hud_x + col * hud_slot_size
    end

    def item_y(row, inventory_height)
      hud_y(inventory_height) + hud_margin + row * hud_slot_size
    end

    def update_struct_info_slot_hovers(mouse : Mouse, inventory_width,  inventory_height)
      storage.times do |index|
        if mouse.hover?(item_x(item_col(index)), item_y(item_row(index), inventory_height), hud_slot_size, hud_slot_size)
          @hover_index = index
        end
      end
    end

    def slot_click_held_item(inventory : Inventory, held_item : Item::Held)
      return unless (hover_index = @hover_index) && accept_item?(held_item.item)

      if hover_index < items.size
        if item = items[hover_index]
          items[hover_index] = inventory.swap_held_item(held_item, item)
        else
          items[hover_index] = held_item.item
          inventory.remove_held_item
        end
      end
    end

    def slot_click_grab_item(inventory : Inventory, mouse : Mouse)
      return unless hover_index = @hover_index

      if hover_index < items.size
        if item = items[hover_index]
          inventory.grab_slot_item(item, mouse)
          items[hover_index] = nil
        end
      end
    end

    def draw_struct_info_slots(inventory_width, inventory_height)
      index = 0

      item_rows.times do |row|
        item_cols.times do |col|
          dx = item_x(col)
          dy = item_y(row, inventory_height)
          item = index < items.size ? items[index] : nil

          if index < storage
            InventoryHUD.draw_slot(dx, dy, item, index == hover_index)
          end

          index += 1
        end
      end
    end
  end
end
