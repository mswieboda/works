require "./base"

module Works::Item::Ore
  class Iron < Base
    Key = :iron
    Name = "Iron"
    ShortCode = "IR"
    MaxAmount = 50
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
