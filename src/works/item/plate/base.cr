require "../base"

module Works::Item::Plate
  class Base < Item::Base
    Key = :plate_base
    Name = "Plate base"
    MaxAmount = 100
    Color = LibAllegro.map_rgb(1, 0, 1)

    @@sprite = LibAllegro.load_bitmap("./assets/plate.png")

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.max_amount
      MaxAmount
    end

    def self.icon_color
      Color
    end

    def self.sprite
      @@sprite
    end

    def draw_icon_text(x, y, size)
      draw_icon_amount_text(x, y, size)
    end
  end
end
