require "./base"
require "../item/struct/stone_furnace"

module Works::Struct
  class StoneFurnace < Base
    Name = "Stone furnace"
    Dimensions = {x: 2, y: 2}
    Color = Item::Struct::StoneFurnace::Color

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.item_class
      Item::Struct::StoneFurnace
    end

    def self.color
      Color
    end
  end
end
