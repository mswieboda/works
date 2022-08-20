require "./base"

module Works::Item::Struct::Inserter
  class Inserter < Base
    Key = :inserter
    Name = "Inserter"
    ShortCode = "IN"
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0.1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.short_code
      ShortCode
    end

    def self.icon_color
      Color
    end
  end
end
