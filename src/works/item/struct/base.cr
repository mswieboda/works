require "./base"
require "../../struct/base"
require "../../struct/stone_furnace"

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

    def to_struct
      case key
      when :stone_furnace
        Works::Struct::StoneFurnace.new
      else
        Works::Struct::Base.new
      end
    end
  end
end
