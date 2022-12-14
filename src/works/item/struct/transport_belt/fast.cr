require "./base"

module Works::Item::Struct::TransportBelt
  class Fast < Base
    Key = :fast_transport_belt
    Name = "Fast transport belt"
    Color = LibAllegro.map_rgb_f(0.75, 0, 0)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.icon_color
      Color
    end
  end
end
