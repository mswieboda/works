require "./base"

module Works::Item::Plate
  class Iron < Base
    Key = :iron_plate
    Name = "Iron plate"
    ShortCode = "I#"
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

    def self.icon_color
      Color
    end
  end
end
