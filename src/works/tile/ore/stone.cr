require "./base"

module Works::Tile::Ore
  class Stone < Base
    Name = "Stone"
    Color = LibAllegro.map_rgb(155, 118, 83)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
