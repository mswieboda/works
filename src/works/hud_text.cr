module Works
  class HUDText
    Margin = 5
    Padding = 3
    BackgroundColor = LibAllegro.map_rgba_f(0, 0, 0, 0.69)
    TextColor = LibAllegro.map_rgba_f(0, 1, 0, 0.69)

    getter text
    getter text_width
    getter text_height

    def initialize(text = "")
      @text = text
      @text_width = LibAllegro.get_text_width(Font.default, @text)
      @text_height = LibAllegro.get_font_line_height(Font.default)
    end

    def inner_width
      Padding + text_width + Padding
    end

    def outer_width
      Margin + inner_width + Margin
    end

    def inner_height
      Padding + text_height + Padding
    end

    def outer_height
      Margin + inner_height + Margin
    end

    def draw_from_bottom(x, y)
      draw_background(x, y - outer_height)
      draw_text(x, y - outer_height)
    end

    def draw_from_right(x, y)
      draw_background(x - outer_width, y)
      draw_text(x - outer_width, y)
    end

    def draw(x, y)
      draw_background(x, y)
      draw_text(x, y)
    end

    def draw_background(x, y)
      LibAllegro.draw_filled_rectangle(
        x + Margin,
        y + Margin,
        x + Margin + inner_width,
        y + Margin + inner_height,
        BackgroundColor
      )
    end

    def draw_text(x, y)
      LibAllegro.draw_text(
        Font.default,
        TextColor,
        x + Margin + Padding,
        y + Margin + Padding,
        0,
        text
      )
    end
  end
end
