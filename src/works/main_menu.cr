require "./scene"

module Works
  class MainMenu < Scene
    property screen_width
    property screen_height
    property? start

    def initialize
      super

      @name = :main_menu
      @start = false
      @fontBig = LibAllegro.create_builtin_font
      @fontNormal = LibAllegro.create_builtin_font
    end

    def initialize(screen_width, screen_height)
      super(screen_width, screen_height)

      @name = :main_menu
      @start = false
      @fontBig = LibAllegro.create_builtin_font
      @fontNormal = LibAllegro.create_builtin_font
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
      LibAllegro.draw_text(@fontBig, LibAllegro.map_rgb(0, 255, 0), screen_width / 2, screen_height / 3, LibAllegro::AlignCentre, "[YOUR GAME NAME HERE]")
      LibAllegro.draw_text(@fontNormal, LibAllegro.map_rgb(0, 255, 0), screen_width / 2, screen_height / 2, LibAllegro::AlignCentre, "press [SPACE] to start!")
    end

    def reset
      super

      @start = false
    end

    def destroy
    end
  end
end
