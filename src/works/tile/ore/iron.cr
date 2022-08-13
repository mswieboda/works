require "./base"

module Works::Tile::Ore
  class Iron < Base
    Name = "Iron"
    Color = LibAllegro.map_rgb(139, 130, 133)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
