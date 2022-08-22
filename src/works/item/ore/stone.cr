require "./base"

module Works::Item::Ore
  class Stone < Base
    Key = :stone
    Name = "Stone"
    Color = LibAllegro.map_rgb(155, 118, 83)

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
