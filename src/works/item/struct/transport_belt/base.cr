require "../base"
require "../../../struct/transport_belt/base"
require "../../../struct/transport_belt/fast"

module Works::Item::Struct::TransportBelt
  class Base < Struct::Base
    Key = :transport_belt
    Name = "Transport belt"
    ShortCode = "TB"
    MaxAmount = 100
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0)

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
      when :transport_belt
        Works::Struct::TransportBelt::Base.new
      when :fast_transport_belt
        Works::Struct::TransportBelt::Fast.new
      else
        raise "#{self.class.name}#to_struct struct not found for #{key}"
      end
    end
  end
end
