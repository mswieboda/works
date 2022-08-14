require "./tile/base"
require "./tile/ore/base"
require "./struct/base"

module Works
  class Map
    getter x
    getter y
    getter width
    getter height
    getter ground
    getter ore
    getter structs

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Tile::Base
      @ore = [] of Tile::Ore::Base
      @structs = [] of Struct::Base
    end

    def draw
      ground.each(&.draw(x, y))
      ore.each(&.draw(x, y))
      structs.each(&.draw(x, y))
    end

    def destroy
      ground.each(&.destroy)
      ore.each(&.destroy)
      structs.each(&.destroy)
    end

    def can_place?(strct : Struct::Base, player : Player)
      return false unless player.buildable?(strct)

      # TODO: impl checks with other structs
      true
    end
  end
end
