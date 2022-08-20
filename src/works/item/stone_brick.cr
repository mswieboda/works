require "./base"

module Works::Item
  class StoneBrick < Base
    Key = :stone_brick
    Name = "Stone brick"
    ShortCode = "SB"
    MaxAmount = 100
    Color = LibAllegro.map_rgb(155, 118, 83)

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
