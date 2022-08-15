require "./base"

module Works::Tile::Ore
  class Coal < Base
    Name = "Coal"
    Color = Item::Ore::Coal::Color

    def self.name
      Name
    end

    def self.item_class
      Item::Ore::Coal
    end

    def self.color
      Color
    end
  end
end
