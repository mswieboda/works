require "./base"

module Works::Tile::Ore
  class Coal < Base
    Name = "Coal"
    Color = LibAllegro.map_rgba_f(0.13, 0.13, 0.13, 0.69)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
