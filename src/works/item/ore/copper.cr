require "./base"

module Works::Item::Ore
  class Copper < Base
    Key = :copper
    Name = "Copper"
    Color = LibAllegro.map_rgb(235, 103, 75)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.icon_color
      Color
    end
  end
end
