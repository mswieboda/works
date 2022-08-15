require "./tile/base"
require "./tile/ore/base"
require "./struct/base"

module Works
  class Map
    getter x
    getter y
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

    def swidth
      Screen::Width
    end

    def sheight
      Screen::Height
    end

    def update_viewport(player_x, player_y)
      @x = (swidth / 2).to_i - player_x
      @y = (sheight / 2).to_i - player_y
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
      cell.x + cell.width + Cell.size >= sx && cell.x.to_i - Cell.size <= sx + swidth &&
        cell.y + cell.height + Cell.size >= sy && cell.y.to_i - Cell.size <= sy + sheight
    end
  end
end
