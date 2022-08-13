require "./base"

module Works::Tile
  class Ground < Base
    Color = LibAllegro.map_rgb(212, 139, 68)

    def draw(x, y)
      draw(x, y, Color)
    end

    def print
      puts "> Ground (#{row}, #{col})"
    end
  end
end
