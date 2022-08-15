require "../base"

module Works::Item::Struct
  abstract class Base < Item::Base
    Key = :struct
    Name = "Struct"
    ShortCode = "SB"
    MaxAmount = 50
    Color = LibAllegro.map_rgb(255, 0, 255)

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

    abstract def to_struct
  end
end
