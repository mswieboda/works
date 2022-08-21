require "./base"

module Works::Item::Struct::Chest
  class Iron < Base
    Key = :iron_chest
    Name = "Iron chest"
    ShortCode = "IC"
    Color = LibAllegro.map_rgb(109, 100, 103)
    Storage = 32

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
