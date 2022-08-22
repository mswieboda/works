require "../base"
require "../../../struct/transport_belt/base"
require "../../../struct/transport_belt/fast"
require "../../../struct/transport_belt/express"

module Works::Item::Struct::TransportBelt
  class Base < Struct::Base
    Key = :transport_belt
    Name = "Transport belt"
    MaxAmount = 100
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0)

    @@sprite = LibAllegro.load_bitmap("./assets/item/struct/transport_belt.png")
    @@sprite_accent = LibAllegro.load_bitmap("./assets/item/struct/transport_belt_accent.png")

    def self.key
      Key
    end

    def self.name
      Name
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

    def self.sprite_accent
      @@sprite_accent
    end

    def sprite_accent
      self.class.sprite_accent
    end

    def to_struct
      case key
      when :transport_belt
        Works::Struct::TransportBelt::Base.new
      when :fast_transport_belt
        Works::Struct::TransportBelt::Fast.new
      when :express_transport_belt
        Works::Struct::TransportBelt::Express.new
      else
        raise "#{self.class.name}#to_struct struct not found for #{key}"
      end
    end

    def draw_icon_background(x, y, size)
      Sprite.draw(sprite, x, y)
      Sprite.draw_tinted(sprite_accent, x, y, icon_color)
    end

    def draw_icon_text(x, y, size)
      draw_icon_amount_text(x, y, size)
    end

    def draw_item(cx, cy)
      Sprite.draw(sprite, cx, cy, center: true)
      Sprite.draw_tinted(sprite_accent, cx, cy, icon_color, center: true)
    end
  end
end
