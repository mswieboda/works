require "./font"

module Works
  class FPSDisplay
    TimeSpan = 1

    Margin = 3 * Screen::ScaleFactor
    Width = 100 * Screen::ScaleFactor
    TextHeight = 10 * Screen::ScaleFactor
    BarHeight = 3 * Screen::ScaleFactor
    DarkShadow = LibAllegro.premul_rgba_f(0, 0, 0, 0.3)
    Green = LibAllegro.premul_rgba_f(0, 1, 0, 0.3)

    def initialize
      @time_start = Time.local
      @time_end = Time.local
      @frames = 0
      @str_fps = ""
      @str_time = ""
      @fps_percent = 0.0
    end

    def calc
      @time_end = Time.local
      time = @time_end - @time_start
      fps = (@frames + 1) / time.total_seconds
      @str_fps = "#{fps.round(2)}"
      @str_time = "#{(time.total_milliseconds / (@frames + 1)).round(1)}ms"
      @fps_percent = time.total_seconds / TimeSpan * 100
      @frames += 1

      if time.total_seconds >= TimeSpan
        @time_start = Time.local
        @frames = 0
      end
    end

    def draw
      LibAllegro.draw_filled_rectangle(Margin, Margin, Width + Margin * 3, Margin * 3 + TextHeight + BarHeight + Margin, DarkShadow)
      LibAllegro.draw_text(Font.default, Green, Margin * 3, Margin * 2, LibAllegro::AlignInteger, @str_fps)
      LibAllegro.draw_text(Font.default, Green, Width + Margin, Margin * 2, LibAllegro::AlignRight, @str_time)
      LibAllegro.draw_filled_rectangle(Margin * 2, Margin * 3 + TextHeight, Margin * 2 + @fps_percent, Margin * 3 + TextHeight + BarHeight, Green)
    end
  end
end
