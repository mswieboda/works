module Works
  class Animation
    property width
    property height
    property frame
    property fps_factor
    property? loops
    property? center
    property sprites

    def initialize
      @width = 0
      @height = 0
      @frame = 0
      @fps_factor = 60
      @loops = true
      @center = true
      @sprites = [] of LibAllegro::Bitmap
    end

    def initialize(fps_factor, loops = true, center = true)
      @width = 0
      @height = 0
      @frame = 0
      @sprites = [] of LibAllegro::Bitmap

      @fps_factor = fps_factor
      @loops = loops
      @center = center
    end

    def add(sheet : LibAllegro::Bitmap, x, y, width, height)
      sprite = LibAllegro.create_sub_bitmap(sheet, x, y, width, height)

      raise "> Animation#add !sprite" unless sprite

      sprites << sprite

      @height = height if height > @height
      @width = width if width > width
    end

    def display_frame
      (frame / fps_factor).to_i
    end

    def update
      max_frames = sprites.size * fps_factor - 1

      @frame += 1 if frame < max_frames
      @frame = 0 if loops? && frame >= max_frames
    end

    def draw(x, y)
      sprite = sprites[display_frame]

      raise "> Animation#draw !sprite" unless sprite

      dx = x
      dy = y

      if center?
        dx -= LibAllegro.get_bitmap_width(sprite) / 2
        dy -= LibAllegro.get_bitmap_height(sprite) / 2
      end

      if Screen.scale_factor > 1
        w = LibAllegro.get_bitmap_width(sprite)
        h = LibAllegro.get_bitmap_height(sprite)

        LibAllegro.draw_scaled_bitmap(sprite, 0, 0, w, h, dx, dy, w * Screen.scale_factor, h * Screen.scale_factor, 0)
      else
        LibAllegro.draw_bitmap(sprite, dx, dy, 0)
      end
    end

    def destroy
      sprites.each do |sprite|
        LibAllegro.destroy_bitmap(sprite)
      end
    end
  end
end
