require "./base"

module Works::Item::Ore
  class Copper < Base
    Key = :copper
    Name = "Copper"
    ShortCode = "CP"
    MaxAmount = 50
    Color = LibAllegro.map_rgb(235, 103, 75)

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
