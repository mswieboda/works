require "./base"

module Works::Item::Struct::Furnace
  class Electric < Base
    Key = :electric_furnace
    Name = "Electric Furnace"
    ShortCode = "EF"
    Color = LibAllegro.map_rgb_f(0.3, 0.3, 0.3)

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

    def self.icon_color
      Color
    end

    def self.sprite
      @@sprite
    end
  end
end
