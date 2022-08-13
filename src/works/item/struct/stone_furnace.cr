require "./base"

module Works::Item::Struct
  class StoneFurnace < Base
    Key = :stone_furnace
    Name = "Stone Furnace"
    ShortCode = "SF"
    MaxAmount = 50
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.short_code
      ShortCode
    end

    def self.max_amount
      MaxAmount
    end

    def self.icon_color
      Color
    end
  end
end
