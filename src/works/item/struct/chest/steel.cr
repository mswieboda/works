require "./base"

module Works::Item::Struct::Chest
  class Steel < Base
    Key = :steel_chest
    Name = "Steel chest"
    ShortCode = "SC"
    Color = LibAllegro.map_rgb(139, 130, 133)
    Storage = 48

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
