require "../mouse"

module Works::Item
  class Held
    getter x : Int32
    getter y : Int32
    getter item : Item::Base
    property strct : Works::Struct::Base | Nil
    getter size : Int32

    def initialize(x, y, item, size)
      @x = x
      @y = y
      @item = item
      @strct = nil
      @size = size
    end

    def update(mouse : Mouse, map : Map)
      @x = mouse.x
      @y = mouse.y

      if strct = @strct
        col, row = mouse.to_map_coords(map.x, map.y)

        # TODO: improve for 2x2, see how factorio does it using half cells when mouse moves
        strct.col = col - ((strct.cols / 2).ceil.to_i - 1)
        strct.row = row - ((strct.rows / 2).ceil.to_i - 1)
      end
    end

    def draw_on_map(x, y)
      if strct = @strct
        strct.draw(x, y)
      else
        draw_item
      end
    end

    def draw_item
      item.draw(x, y, size)
    end
  end
end
