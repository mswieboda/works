require "./base"

module Works::Struct::Furnace
  class Electric < Base
    Key = :electric_furnace
    Name = "Electric furnace"
    Dimensions = {x: 3, y: 3}
    Color = LibAllegro.map_rgb_f(0.3, 0.3, 0.3)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.color
      Color
    end
  end
end
