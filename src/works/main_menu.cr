require "./scene"

module Works
  class MainMenu < Scene
    property? start

    def initialize
      super

      @name = :main_menu
      @start = false
    end

    def init
    end

    def update(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyEscape)
        @exit = true
        return
      end

      @start = true if keys.just_pressed?(LibAllegro::KeySpace)
    end

    def draw
      LibAllegro.draw_text(Font.default, LibAllegro.map_rgb(0, 255, 0), Screen::Width / 2, Screen::Height / 3, LibAllegro::AlignCentre, "[YOUR GAME NAME HERE]")
      LibAllegro.draw_text(Font.default, LibAllegro.map_rgb(0, 255, 0), Screen::Width / 2, Screen::Height / 2, LibAllegro::AlignCentre, "press [SPACE] to start!")
    end

    def reset
      super

      @start = false
    end

    def destroy
    end
  end
end
