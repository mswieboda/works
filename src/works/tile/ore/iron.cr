require "./base"
require "../../item/ore/iron"

module Works::Tile::Ore
  class Iron < Base
    Name = "Iron"
    Color = Item::Ore::Iron::Color

    def self.name
      Name
    end

    def self.item_class
      Item::Ore::Iron
    end

    def self.color
      Color
    end
  end
end
