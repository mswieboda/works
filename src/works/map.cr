require "./tile/base"
require "./tile/ore/base"
require "./struct/base"

module Works
  class Map
    property x
    property y
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

    def get_struct(mouse)
      col, row = mouse.to_map_coords(x, y)

      structs.find(&.hover?(col, row))
    end
  end
end
