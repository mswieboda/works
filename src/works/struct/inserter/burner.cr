require "./base"

module Works::Struct::Inserter
  class Burner < Base
    Key = :burner_inserter
    Name = "Burner inserter"
    Color = LibAllegro.map_rgb_f(0.75, 0.75, 0.1)

    property fuel_item : Item::Base | Nil

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @fuel_item = nil
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def update

    end
  end
end
