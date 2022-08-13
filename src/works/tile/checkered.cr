require "./base"

module Works::Tile
  class Checkered < Base
    Name = "Checkered"
    OddColor = LibAllegro.map_rgba_f(0, 0.13, 0, 0.13)
    EvenColor = LibAllegro.map_rgba_f(0, 0, 0.13, 0.13)

    def self.name
      Name
    end

    def self.color
      OddColor
    end

    def color
      same = [row, col].all?(&.odd?) || [row, col].all?(&.even?)

      same ? OddColor : EvenColor
    end
  end
end
