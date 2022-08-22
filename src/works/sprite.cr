module Works
  class Sprite
    NoTintColor = LibAllegro.map_rgb_f(1, 1, 1)

    def self.draw(sprite : LibAllegro::Bitmap, x, y, center = false, flip_horizontal = false, flip_vertical = false)
      dx = x
      dy = y

      if center
        dx -= LibAllegro.get_bitmap_width(sprite) / 2
        dy -= LibAllegro.get_bitmap_height(sprite) / 2
      end

      flags = 0
      flags |= LibAllegro::FlipHorizontal if flip_horizontal
      flags |= LibAllegro::FlipVertical if flip_vertical

      if Screen.sprite_factor == 1.0
        LibAllegro.draw_bitmap(sprite, dx, dy, flags)
      else
        w = LibAllegro.get_bitmap_width(sprite)
        h = LibAllegro.get_bitmap_height(sprite)

        LibAllegro.draw_scaled_bitmap(sprite, 0, 0, w, h, dx, dy, w * Screen.sprite_factor, h * Screen.sprite_factor, flags)
      end
    end

    def self.draw_tinted(sprite : LibAllegro::Bitmap, x, y, tint = NoTintColor, center = false, flip_horizontal = false, flip_vertical = false)
      dx = x
      dy = y

      if center
        dx -= LibAllegro.get_bitmap_width(sprite) / 2
        dy -= LibAllegro.get_bitmap_height(sprite) / 2
      end

      flags = 0
      flags |= LibAllegro::FlipHorizontal if flip_horizontal
      flags |= LibAllegro::FlipVertical if flip_vertical

      if Screen.sprite_factor == 1.0
        LibAllegro.draw_tinted_bitmap(sprite, tint, dx, dy, flags)
      else
        w = LibAllegro.get_bitmap_width(sprite)
        h = LibAllegro.get_bitmap_height(sprite)

        LibAllegro.draw_tinted_scaled_bitmap(sprite, tint, 0, 0, w, h, dx, dy, w * Screen.sprite_factor, h * Screen.sprite_factor, flags)
      end
    end
  end
end