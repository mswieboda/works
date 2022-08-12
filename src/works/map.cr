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
      coal_tiles.select(&.hover?).each(&.clear_hover)

      map_mouse = Mouse.new(mouse.x - x, mouse.y - y)

      row = (map_mouse.y / Coal::Size).to_i
      col = (map_mouse.x / Coal::Size).to_i

      if coal = coal_tiles.find { |c| c.row == row && c.col == col }
        coal.hover
      end
    end

    def draw
      ground_tiles.each(&.draw(x, y))
      coal_tiles.each(&.draw(x, y))
      tiles.each(&.draw(x, y))
    end

    def destroy
      ground_tiles.each(&.destroy)
      coal_tiles.each(&.destroy)
      tiles.each(&.destroy)
    end
  end
end
