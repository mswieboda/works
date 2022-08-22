require "./base"

module Works::Item::Ore
  class Coal < Base
    Key = :coal
    Name = "Coal"
    Color = LibAllegro.map_rgb(33, 35, 39)

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
