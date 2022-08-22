require "../base"

module Works::Item::Plate
  class Base < Item::Base
    Key = :plate_base
    Name = "Plate base"
    ShortCode = "P#"
    MaxAmount = 100
    Color = LibAllegro.map_rgb(1, 0, 1)

    @@sprite = LibAllegro.load_bitmap("./assets/plate.png")

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

    def self.sprite
      @@sprite
    end

    def sprite
      self.class.sprite
    end

    def draw_icon_background(x, y, size)
      Sprite.draw_tinted(sprite, x, y, icon_color)
    end

    def draw_item(cx, cy)
      Sprite.draw_tinted(sprite, cx, cy, icon_color, center: true)
    end
  end
end
