require "./sprite"

module Works
  class Animation
    getter width
    getter height
    getter frame
    getter fps_factor
    getter? loops
    getter? center
    getter sprites
    getter? paused

    def initialize(fps_factor = 60, loops = true, center = false)
      @width = 0
      @height = 0
      @frame = 0
      @sprites = [] of LibAllegro::Bitmap

      @fps_factor = fps_factor
      @loops = loops
      @center = center
      @paused = false
    end

    def add(sheet : LibAllegro::Bitmap, x, y, width, height)
      sprite = LibAllegro.create_sub_bitmap(sheet, x, y, width, height)

      raise "> Animation#add !sprite" unless sprite

      sprites << sprite

      @height = height if height > @height
      @width = width if width > width
    end

    def restart
      @paused = false
      @frame = 0
    end

    def done?
      frame >= total_frames
    end

    def pause
      @paused = true
    end

    def display_frame
      (frame / fps_factor).to_i
    end

    def total_frames
      sprites.size * fps_factor - 1
    end

    def update
      return if paused?

      restart if loops? && done?

      @frame += 1 if frame < total_frames
    end

    def draw(x, y, flip_horizontal = false, flip_vertical = false)
      if sprite = sprites[display_frame]
        Sprite.draw(sprite, x, y, center: center?, flip_horizontal: flip_horizontal, flip_vertical: flip_vertical)
      else
        raise "> Animation#draw !sprite"
      end
    end

    def draw_rotated(x, y, angle = 0.0, flip_horizontal = false, flip_vertical = false)
      if sprite = sprites[display_frame]
        Sprite.draw_rotated(sprite, x, y, angle: angle, center: center?, flip_horizontal: flip_horizontal, flip_vertical: flip_vertical)
      else
        raise "> Animation#draw !sprite"
      end
    end

    def destroy
      sprites.each do |sprite|
        LibAllegro.destroy_bitmap(sprite)
      end
    end
  end
end
