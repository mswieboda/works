require "../base"

module Works::Item::Ore
  abstract class Base < Item::Base
    Key = :ore
    Name = "Ore"
    ShortCode = "CP"
    MaxAmount = 50
    Color = LibAllegro.map_rgb(255, 0, 255)

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
