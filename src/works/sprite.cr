module Works
  class Sprite
    NoTintColor = LibAllegro.map_rgb_f(1, 1, 1)

    def self.draw(sprite : LibAllegro::Bitmap, x, y, scale = 1.0, center = false, flip_horizontal = false, flip_vertical = false)
      dx = x
      dy = y
      scale *= Screen.sprite_factor

      if center
        dx -= LibAllegro.get_bitmap_width(sprite) / 2
        dy -= LibAllegro.get_bitmap_height(sprite) / 2
      end

      flags = 0
      flags |= LibAllegro::FlipHorizontal if flip_horizontal
      flags |= LibAllegro::FlipVertical if flip_vertical

      if scale == 1.0
        LibAllegro.draw_bitmap(sprite, dx, dy, flags)
      else
        w = LibAllegro.get_bitmap_width(sprite)
        h = LibAllegro.get_bitmap_height(sprite)

        LibAllegro.draw_scaled_bitmap(sprite, 0, 0, w, h, dx, dy, w * scale, h * scale, flags)
      end
    end

    def self.draw_rotated(sprite : LibAllegro::Bitmap, x, y, scale = 1.0, angle = 0.0, center = false, flip_horizontal = false, flip_vertical = false)
      cx = LibAllegro.get_bitmap_width(sprite) / 2
      cy = LibAllegro.get_bitmap_height(sprite) / 2

      dx = x
      dy = y
      scale *= Screen.sprite_factor

      unless center
        dx += LibAllegro.get_bitmap_width(sprite) * scale / 2
        dy += LibAllegro.get_bitmap_height(sprite) * scale / 2
      end

      flags = 0
      flags |= LibAllegro::FlipHorizontal if flip_horizontal
      flags |= LibAllegro::FlipVertical if flip_vertical

      LibAllegro.draw_scaled_rotated_bitmap(sprite, cx, cy, dx, dy, scale, scale, angle * Math::PI / 180, flags)
    end

    def self.draw_tinted(sprite : LibAllegro::Bitmap, x, y, tint = NoTintColor, scale = 1.0, center = false, flip_horizontal = false, flip_vertical = false)
      dx = x
      dy = y
      scale *= Screen.sprite_factor

      if center
        dx -= LibAllegro.get_bitmap_width(sprite) * scale / 2
        dy -= LibAllegro.get_bitmap_height(sprite) * scale / 2
      end

      flags = 0
      flags |= LibAllegro::FlipHorizontal if flip_horizontal
      flags |= LibAllegro::FlipVertical if flip_vertical

      if scale == 1.0
        LibAllegro.draw_tinted_bitmap(sprite, tint, dx, dy, flags)
      else
        w = LibAllegro.get_bitmap_width(sprite)
        h = LibAllegro.get_bitmap_height(sprite)

        LibAllegro.draw_tinted_scaled_bitmap(sprite, tint, 0, 0, w, h, dx, dy, w * scale, h * scale, flags)
      end
    end
  end
end
