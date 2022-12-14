require "./base"

module Works::Item::Plate
  class Steel < Base
    Key = :steel_plate
    Name = "Steel plate"
    Color = LibAllegro.map_rgb(139, 130, 133)

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
