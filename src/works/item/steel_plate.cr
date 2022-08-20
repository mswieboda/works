require "./base"

module Works::Item
  class SteelPlate < Base
    Key = :steel_plate
    Name = "Steel plate"
    ShortCode = "S#"
    MaxAmount = 100
    Color = LibAllegro.map_rgb(139, 130, 133)

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
