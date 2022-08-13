require "./base"
require "../../item/ore/copper"

module Works::Tile::Ore
  class Copper < Base
    Name = "Copper"
    Color = Item::Ore::Copper::Color

    def self.name
      Name
    end

    def self.item_class
      Item::Ore::Copper
    end

    def self.color
      Color
    end
  end
end
