require "./base"

module Works::Item::Struct::Chest
  class Wooden < Base
    Key = :wooden_chest
    Name = "Wooden chest"
    ShortCode = "WC"
    Color = LibAllegro.map_rgb_f(0.37, 0.29, 0.21)
    Storage = 16

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

    def self.storage
      Storage
    end
  end
end
