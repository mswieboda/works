require "../base"

module Works::Item::Ore
  abstract class Base < Item::Base
    Key = :ore
    Name = "Ore"
    MaxAmount = 50
    Color = LibAllegro.map_rgb(255, 0, 255)

    @@sprite = LibAllegro.load_bitmap("./assets/item/ore.png")

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
