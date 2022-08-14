require "./base"
require "../item/struct/stone_furnace"

module Works::Struct
  class StoneFurnace < Base
    Name = "StoneFurnace"
    Dimensions = {x: 2, y: 2}
    Color = Item::Struct::StoneFurnace::Color

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.dimensions
      Dimensions
    end
  end
end
