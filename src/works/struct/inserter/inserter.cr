require "./base"

module Works::Struct::Inserter
  class Inserter < Base
    Key = :inserter
    Name = "Inserter"
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0.1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end
  end
end
