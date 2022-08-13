require "./animations"
require "./hud_text"

module Works
  class Player
    MiningDistance = 64

    property x
    property y
    property speed
    property animations
    getter coal_hover : Coal | Nil

    def initialize
      @y = 0
      @x = 0
      @speed = 0
      @animations = Animations.new
      @coal_hover = nil
    end

    def init_animations(sheet : LibAllegro::Bitmap)
      idle = Animation.new((FPS / 3).to_i)
      size = 64
      idle_frames = 5

      idle_frames.times do |i|
        idle.add(sheet, i * size, 0, size, size)
      end

      idle_walk_left = Animation.new((FPS / 3).to_i)
      idle_walk_left_frames = 4

      idle_walk_left_frames.times do |i|
        i += idle_frames
        idle_walk_left.add(sheet, i * size, 0, size, size)
      end

      animations.add(idle, :idle)
      animations.add(idle_walk_left, :idle_walk_left)
      animations.play(:idle)
    end

    def width
      48 # temp until calc'ed from sprite
    end

    def height
      64 # temp until calc'ed from sprite
    end

    def update(keys : Keys, mouse : Mouse, map : Map)
      animations.update

      dx = 0
      dy = 0

      dy -= speed if keys.pressed?([LibAllegro::KeyUp, LibAllegro::KeyW])
      dy += speed if keys.pressed?([LibAllegro::KeyDown, LibAllegro::KeyS])

      if keys.pressed?([LibAllegro::KeyLeft, LibAllegro::KeyA])
        dx -= speed
        animations.play(:idle_walk_left)
      end

      dx += speed if keys.pressed?([LibAllegro::KeyRight, LibAllegro::KeyD])

      if dx == 0 && dy == 0
        animations.play(:idle)
      else
        @x += dx
        @y += dy
      end

      update_mining(mouse, map)
    end

    def update_mining(mouse : Mouse, map : Map)
      @coal_hover = nil

      mx, my = mouse.to_map_coords(map.x, map.y)

      row = (my / Coal.size).to_u16
      col = (mx / Coal.size).to_u16

      coal = map.coal.find { |c| c.row == row && c.col == col }

      return unless coal
      return unless distance(coal) < MiningDistance

      @coal_hover = coal

      return unless mouse.right_pressed?

      coal.amount -= 1
    end

    def distance(tile : Tile)
      player_x = x
      player_y = y
      tile_x = tile.x + tile.width / 2
      tile_y = tile.y + tile.height / 2

      dx = player_x - tile_x
      dy = player_y - tile_y

      Math.sqrt(dx * dx + dy * dy).to_i
    end

    def draw(x, y)
      if coal_hover = @coal_hover
        coal_hover.draw_hover(x, y)
      end

      animations.draw(x + @x, y + @y)
    end

    def destroy
      animations.destroy
    end
  end
end
