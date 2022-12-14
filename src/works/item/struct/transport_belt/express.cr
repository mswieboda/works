require "./base"

module Works::Item::Struct::TransportBelt
  class Express < Base
    Key = :express_transport_belt
    Name = "Express transport belt"
    Color = LibAllegro.map_rgb_f(0.25, 0.5, 0.9)

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
