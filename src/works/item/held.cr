require "../mouse"

module Works::Item
  class Held
    getter x : Int32
    getter y : Int32
    getter item : Item::Base
    property strct : Works::Struct::Base | Nil
    getter size : Int32
    getter? player_buildable
    getter? player_overlaps
    getter struct_overlaps : Array(Works::Struct::Base)

    def initialize(x, y, item, size)
      @x = x
      @y = y
      @item = item
      @strct = nil
      @size = size
      @player_buildable = false
      @player_overlaps = false
      @struct_overlaps = [] of Works::Struct::Base
    end

    def buildable?
      strct && player_buildable? && !player_overlaps? && struct_overlaps.empty?
    end

    def update(mouse : Mouse, map : Map, player : Player)
      @x = mouse.x
      @y = mouse.y

      if strct = @strct
        col, row = mouse.to_map_coords(map.x, map.y)

        # TODO: improve for 2x2, see how factorio does it using half cells when mouse moves
        strct.col = col - ((strct.cols / 2).ceil.to_i - 1)
        strct.row = row - ((strct.rows / 2).ceil.to_i - 1)

        @player_buildable = player.buildable?(strct)
        @player_overlaps = player.overlaps?(strct)
        @struct_overlaps = map.structs.select(&.overlaps?(strct))
      end
    end

    def draw_on_map(x, y, color_tint)
      if strct = @strct
        strct.draw(x, y)

        if tint = color_tint
          draw_color_tint(x + strct.x, y + strct.y, strct.width, strct.height, tint)
        end
      else
        draw_item
      end
    end

    def draw_item
      item.draw(x, y, size)
    end

    def draw_color_tint(x, y, width, height, tint)
      LibAllegro.draw_filled_rectangle(x, y, x + width, y + height, tint)
    end
  end
end
