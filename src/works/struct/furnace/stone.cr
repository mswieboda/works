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

    def output_duration(item : Item::Base) : Time::Span
      case item
      when Item::Ore::Copper, Item::Ore::Iron, Item::Ore::Stone
        3.2.seconds
      # when Item::IronPlate
      #   16.seconds
      else
        0.seconds
      end
    end
  end
end
