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

    def output_duration(item : Item::Base) : Time::Span
      case item
      when Item::Ore::Iron, Item::Ore::Copper, Item::Ore::Stone
        1.6.seconds
      when Item::IronPlate
        8.seconds
      else
        0.seconds
      end
    end
  end
end
