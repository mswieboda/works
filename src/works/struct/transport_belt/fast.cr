require "./base"

module Works::Struct::TransportBelt
  class Fast < Base
    Key = :fast_transport_belt
    Name = "Fast transport belt"
    Color = LibAllegro.map_rgb_f(0.75, 0, 0)
    BeltSpeed = 2

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.belt_speed
      BeltSpeed
    end
  end
end
