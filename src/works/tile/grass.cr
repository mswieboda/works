require "./base"

module Works::Tile
  class Grass < Base
    Name = "Grass"
    Color = LibAllegro.map_rgb_f(0.15, 0.29, 0.05)

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
