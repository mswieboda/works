require "./base"

module Works::Tile::Ore
  class Coal < Base
    Name = "Coal"
    Color = LibAllegro.map_rgb_f(0.13, 0.13, 0.13)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
