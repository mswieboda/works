require "./base"

module Works::UI
  class ProgressBar < Base
    BackgroundColor = LibAllegro.premul_rgba_f(0, 0, 0, 0.3)
    Color = LibAllegro.map_rgb_f(1, 1, 1)
    Margin = 3 * Screen.scale_factor
    Padding = 3 * Screen.scale_factor

    property progress : Float64
    property color

    def initialize(width, height, progress, color = Color)
      super(width, height, Margin, Padding)

      @progress = progress
      @color = color
    end

    def draw_from_bottom(x, y)
      draw(x, y - outer_height)
    end

    def draw(x, y)
      draw_background(x, y)
      draw_progress_bar(x, y)
    end

    def draw_background(x, y)
      LibAllegro.draw_filled_rectangle(
        x + margin,
        y + margin,
        x + margin + padding + width + padding,
        y + margin + padding + height + padding,
        BackgroundColor
      )
    end

    def draw_progress_bar(x, y)
      progress_width = (progress * width).round(1)

      LibAllegro.draw_filled_rectangle(
        x + margin + padding,
        y + margin + padding,
        x + margin + padding + progress_width,
        y + margin + padding + height,
        color
      )
    end
  end
end
