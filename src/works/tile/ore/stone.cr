require "./base"
# require "../../item/ore/stone"

module Works::Tile::Ore
  class Stone < Base
    Name = "Stone"
    Color = Item::Ore::Stone::Color

    def self.name
      Name
    end

    def self.item_class
      Item::Ore::Stone
    end

    def self.color
      Color
    end
  end
end
