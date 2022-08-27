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
    getter viewables

    def initialize
      @x = 0
      @y = 0
      @ground = [] of Array(Tile::Base)
      @ore = [] of Array(Tile::Ore::Base | Nil)
      @structs = [] of Struct::Base
      @viewables = [] of Cell

      Struct::TransportBelt::Base.init_animation
    end

    def sx
      -x
    end

    def sy
      -y
    end

    def swidth
      Screen.width
    end

    def sheight
      Screen.height
    end

    def update_viewport(player_x, player_y)
      @x = (swidth / 2).to_i - player_x
      @y = (sheight / 2).to_i - player_y
    end

    def update
      @viewables.clear
      @viewables += viewables_grid(ground)
      @viewables += viewables_grid(ore)
      @viewables += viewables(structs.reject(&.is_a?(Struct::Inserter::Base)))
      @viewables += viewables(structs.select(&.is_a?(Struct::Inserter::Base)))

      structs.each(&.update(self))

      Struct::TransportBelt::Base.update
      Struct::TransportBelt::Fast.update
      Struct::TransportBelt::Express.update
    end

    def draw
      viewables.each(&.draw(x, y))
      structs.select(&.is_a?(Struct::TransportBelt::Base)).map(&.as(Struct::TransportBelt::Base)).each(&.draw_lanes(x, y))
    end

    def destroy
      ground.flatten.each(&.destroy)
      ore.flatten.compact.each(&.destroy)
      structs.each(&.destroy)

      Struct::TransportBelt::Base.destroy
    end

    def inbounds?(col, row)
      # TODO: add max bounds
      col > 0 && row > 0
    end

    def inbounds?(strct : Struct::Base)
      # TODO: change to also use dimensions when using max bounds
      inbounds?(strct.col, strct.row)
    end

    def get_ore(col, row)
      if col <= ore.size - 1
        ore_col = ore[col]

        return ore_col[row] if row <= ore_col.size - 1
      end

      nil
    end

    def get_struct(mouse)
      col, row = mouse.to_map_coords(x, y)

      structs.find(&.hover?(col, row))
    end

    def viewport_col_min
      ((sx - Cell.size) / Cell.size).round.to_i
    end

    def viewport_col_max
      ((sx + swidth + Cell.size) / Cell.size).round.to_i
    end

    def viewport_row_min
      ((sy - Cell.size) / Cell.size).round.to_i
    end

    def viewport_row_max
      ((sy + sheight + Cell.size) / Cell.size).round.to_i
    end

    def viewables_grid(cells : Array(Array(Cell | Nil)))
      cols = cells[viewport_col_min.clamp(0, nil)..viewport_col_max]

      cols.flat_map do |col|
        col[viewport_row_min.clamp(0, nil)..viewport_row_max]
      end.compact
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
