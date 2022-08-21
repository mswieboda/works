require "./base"

module Works::Item
  class IronPlate < Base
    Key = :iron_plate
    Name = "Iron plate"
    ShortCode = "I#"
    MaxAmount = 100
    Color = LibAllegro.map_rgb(109, 100, 103)

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
