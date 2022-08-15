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
      @ground = [] of Tile::Base
      @ore = [] of Tile::Ore::Base
      @structs = [] of Struct::Base
    end

    def sx
      -x
    end

    def sy
      -y
    end

    def width
      Screen::Width
    end

    def height
      Screen::Height
    end

    def draw
      viewables(ground).each(&.draw(x, y))
      viewables(ore).each(&.draw(x, y))
      viewables(structs).each(&.draw(x, y))
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

    def viewables(cells : Array(Cell))
      cells.select { |c| viewable?(c) }
    end

    def viewable?(cell : Cell)
      cell.x + cell.width + Cell.size >= sx && cell.x.to_i - Cell.size <= sx + width &&
        cell.y + cell.height + Cell.size >= sy && cell.y.to_i - Cell.size <= sy + height
    end
  end
end
