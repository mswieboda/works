require "./animations"

module Works
  class Player
    property x
    property y
    property speed
    property animations

    def initialize
      @y = 0
      @x = 0
      @speed = 0
      @animations = Animations.new
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

    def update(keys : Keys)
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
    end

    def draw(x, y)
      animations.draw(x + @x, y + @y)
    end

    def destroy
      animations.destroy
    end
  end
end
