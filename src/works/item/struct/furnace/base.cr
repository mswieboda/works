require "../base"
require "../../../struct/furnace/stone"
require "../../../struct/furnace/electric"

module Works::Item::Struct::Furnace
  class Base < Struct::Base
    Key = :furnace
    Name = "furnace"
    ShortCode = "FB"
    MaxAmount = 50
    Color = LibAllegro.map_rgb_f(1, 0, 1)

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
        Works::Struct::Furnace::Stone.new
      when :electric_furnace
        Works::Struct::Furnace::Electric.new
      else
        raise "#{self.class.name}#to_struct struct not found for #{key}"
      end
    end
  end
end
