require "./base"

module Works::Tile::Ore
  class Copper < Base
    Name = "Copper"
    Color = LibAllegro.map_rgb(235, 103, 75)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
