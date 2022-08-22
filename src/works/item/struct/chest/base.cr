require "../base"
require "../../../struct/chest/wooden"
require "../../../struct/chest/iron"
require "../../../struct/chest/steel"

module Works::Item::Struct::Chest
  abstract class Base < Struct::Base
    Key = :chest_base
    Name = "Chest base"
    ShortCode = "CB"
    MaxAmount = 50
    Color = LibAllegro.map_rgb_f(1, 0, 1)

    @@sprite = LibAllegro.load_bitmap("./assets/item/struct/chest.png")

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

    def draw_icon_text(x, y, size)
      draw_icon_amount_text(x, y, size)
    end

    def to_struct
      case key
      when :wooden_chest
        Works::Struct::Chest::Wooden.new
      when :iron_chest
        Works::Struct::Chest::Iron.new
      when :steel_chest
        Works::Struct::Chest::Steel.new
      else
        raise "#{self.class.name}#to_struct struct not found for #{key}"
      end
    end
  end
end
