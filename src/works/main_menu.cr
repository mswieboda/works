require "./scene"
require "./font"

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
      LibAllegro.draw_text(Font.big, LibAllegro.map_rgb(0, 255, 0), Screen.width / 2, Screen.height / 3, LibAllegro::AlignCentre, "[YOUR GAME NAME HERE]")
      LibAllegro.draw_text(Font.normal, LibAllegro.map_rgb(0, 255, 0), Screen.width / 2, Screen.height / 2, LibAllegro::AlignCentre, "press [SPACE] to start!")
    end

    def reset
      super

      @start = false
    end

    def destroy
    end
  end
end
