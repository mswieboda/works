require "./scene"

module Works
  class MainMenu < Scene
    property screen_width
    property screen_height
    property? start

    def initialize
      super

      @screen_width = 0
      @screen_height = 0
      @start = false
      # @fontBig = al_load_font("./assets/PressStart2P.ttf", 64, 0)
      # @fontNormal = al_load_font("./assets/PressStart2P.ttf", 24, 0)
    end

    def initialize(screen_width, screen_height)
      super()

      @start = false
      # @fontBig = LibAllegro.load_font("./assets/PressStart2P.ttf", 64, 0)
      # @fontNormal = LibAllegro.load_font("./assets/PressStart2P.ttf", 24, 0)

      @screen_width = screen_width
      @screen_height = screen_height
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
    end

    def reset
      super

      @start = false
    end

    def destroy
    end
  end
end
