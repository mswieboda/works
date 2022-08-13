require "./base"

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

    def icon_color
      self.class.icon_color
    end

    def draw_icon(x, y, size)
      # TODO: switch to rounded rect or triangle
      LibAllegro.draw_filled_circle(x + size / 2, y + size / 2, size / 2, icon_color)
    end
  end
end
