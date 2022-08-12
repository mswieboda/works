require "./tile"

module Works
  class Ground < Tile
    def draw(x, y)
      color = LibAllegro.map_rgb(212, 139, 68)

      draw(x, y, color)
    end

    def print
      puts "> Ground (#{row}, #{col})"
    end
  end
end
