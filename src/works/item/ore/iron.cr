require "./base"

module Works::Item::Ore
  class Iron < Base
    Key = :iron
    Name = "Iron"
    Color = LibAllegro.map_rgb(109, 100, 103)

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
