require "../mouse"

module Works::Item
  class Held
    getter x : Int32
    getter y : Int32
    property item : Item::Base
    property strct : Works::Struct::Base | Nil
    getter size : Int32
    getter? struct_inbounds
    getter? player_buildable
    getter? player_overlaps
    getter struct_overlaps : Array(Works::Struct::Base)
    getter struct_overwrite : Works::Struct::Base | Nil

    def initialize(x, y, item, size)
      @x = x
      @y = y
      @item = item
      @strct = nil
      @size = size
      @struct_inbounds = false
      @player_buildable = false
      @player_overlaps = false
      @struct_overlaps = [] of Works::Struct::Base
      @struct_overwrite = nil
    end

    def buildable?
      strct && struct_inbounds? && player_buildable? && !player_overlaps? && struct_overlaps.empty?
    end

    def update(mouse : Mouse, map : Map, player : Player)
      @x = mouse.x
      @y = mouse.y

      if strct = @strct
        col, row = mouse.to_map_coords_centered(map.x, map.y, strct.cols, strct.rows)

        strct.col = col
        strct.row = row

        @struct_inbounds = map.inbounds?(strct)
        @player_buildable = player.buildable?(strct)
        @player_overlaps = player.overlaps?(strct)
        @struct_overlaps = map.structs.select(&.overlaps?(strct))
        @struct_overwrite = map.structs.find { |s| s.overlaps?(strct) && s.can_overwrite?(strct) }
        @struct_overlaps.reject! { |s| s == @struct_overwrite }
      end
    end

    def rotate
      if strct = @strct
        strct.rotate
      end
    end

    def draw_on_map(x, y, color_tint)
      if strct = @strct
        strct.draw(x, y)

        if tint = color_tint
          draw_color_tint(x + strct.x, y + strct.y, strct.width, strct.height, tint)
        end
      else
        draw_icon
      end
    end

    def draw_icon
      item.draw_icon(x, y, size)
    end

    def draw_color_tint(x, y, width, height, tint)
      LibAllegro.draw_filled_rectangle(x, y, x + width, y + height, tint)
    end
  end
end
