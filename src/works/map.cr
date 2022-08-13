require "./tile/base"
require "./tile/ore/base"

module Works
  class Map
    getter x
    getter y
    getter width
    getter height
    getter ground
    getter ore

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Tile::Base
      @ore = [] of Tile::Ore::Base
    end

    def draw
      ground.each(&.draw(x, y))
      ore.each(&.draw(x, y))
    end

    def destroy
      ground.each(&.destroy)
      ore.each(&.destroy)
    end
  end
end
