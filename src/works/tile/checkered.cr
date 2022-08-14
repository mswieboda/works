require "./base"

module Works::Tile
  class Checkered < Base
    Name = "Checkered"
    OddColor = LibAllegro.premul_rgba_f(0, 1, 0, 0.13)
    EvenColor = LibAllegro.premul_rgba_f(0, 0, 1, 0.13)

    def self.name
      Name
    end

    def self.color
      OddColor
    end

    def color
      same = [col, row].all?(&.odd?) || [col, row].all?(&.even?)

      same ? OddColor : EvenColor
    end
  end
end
