require "./base"

module Works::Struct::Furnace
  class Stone < Base
    Key = :stone_furnace
    Name = "Stone furnace"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
