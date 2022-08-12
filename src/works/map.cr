require "./ground"
require "./coal"
require "./tile"
require "./mouse"

module Works
  class Map
    property x
    property y
    property width
    property height
    property ground_tiles
    property coal_tiles
    property tiles

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground_tiles = [] of Ground
      @coal_tiles = [] of Coal
      @tiles = [] of Tile
    end

    def update(mouse : Mouse)
      map_mouse = Mouse.new(mouse.x - x, mouse.y - y)

      ground_tiles.each(&.update(map_mouse))
      coal_tiles.each(&.update(map_mouse))
      tiles.each(&.update(map_mouse))
    end

    def draw
      ground_tiles.each(&.draw(x, y))
      coal_tiles.each(&.draw(x, y))
      tiles.each(&.draw(x, y))
    end

    def destroy
      coal_tiles.each(&.destroy)
      ground_tiles.each(&.destroy)
      tiles.each(&.destroy)
    end
  end
end
