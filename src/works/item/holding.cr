require "./base"

module Works::Item
  class Holding < Base
    Key = :holding
    Name = "Holding"
    ShortCode = "HD"
    MaxAmount = 1
    Color = LibAllegro.map_rgb_f(0.5, 0, 0)

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
