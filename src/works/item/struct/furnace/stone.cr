require "./base"

module Works::Item::Struct::Furnace
  class Stone < Base
    Key = :stone_furnace
    Name = "Stone Furnace"
    ShortCode = "SF"
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    @@sprite = LibAllegro.load_bitmap("./assets/item/struct/stone_furnace.png")

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

    def self.sprite
      @@sprite
    end
  end
end
