require "./base"

module Works::Item::Plate
  class Copper < Base
    Key = :copper_plate
    Name = "Copper plate"
    ShortCode = "C#"
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

    def self.icon_color
      Color
    end
  end
end
