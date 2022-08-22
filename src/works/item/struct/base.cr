require "../base"

module Works::Item::Struct
  abstract class Base < Item::Base
    Key = :struct
    Name = "Struct"
    ShortCode = "SB"
    MaxAmount = 50
    Color = LibAllegro.map_rgb(255, 0, 255)

    @@sprite = LibAllegro.load_bitmap("./assets/item/struct/base.png")

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

    abstract def to_struct
  end
end
