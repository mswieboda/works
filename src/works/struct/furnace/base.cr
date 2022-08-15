require "../base"

module Works::Struct::Furnace
  abstract class Base < Struct::Base
    Key = :furnace
    Name = "furnace"
    Dimensions = {x: 2, y: 2}
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.color
      Color
    end

    def item_class
      case key
      when :stone_furnace
        Item::Struct::Furnace::Stone
      when :electric_furnace
        Item::Struct::Furnace::Electric
      else
        Item::Struct::Furnace::Base
      end
    end
  end
end
