require "../base"

module Works::Struct::Chest
  abstract class Base < Struct::Base
    Key = :chest_base
    Name = "Chest base"
    Color = LibAllegro.map_rgb_f(1, 0, 1)
    Storage = 1

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
  end
end
