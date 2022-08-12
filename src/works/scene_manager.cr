require "./scene"
require "./keys"
require "./mouse"
require "./main_menu"

module Works
  class SceneManager < Scene
    property? redraw
    property keys
    property mouse
    property scene : Scene

    property mainMenu
    # property gameScene

    def initialize(screen_width, screen_height)
      super()

      @redraw = false

      @keys = Keys.new
      @mouse = Mouse.new

      @mainMenu = MainMenu.new
      # @gameScene = GameScene.new

      @scene = mainMenu
    end

    def init
    end

    def update(event : LibAllegro::Event)
      case(event.type)
      when LibAllegro::EventTimer
        check_scenes
        update(keys, mouse)
        keys.reset

        @redraw = true
      when LibAllegro::EventMouseAxes
        # TODO: make a mouse input holder, similar to Keys
        #       then put both Keys and Mouse inside Input ?
        mouse.x = event.mouse.x;
        mouse.y = event.mouse.y;
      when LibAllegro::EventKeyDown
        keys.pressed(event.keyboard.keycode)
      when LibAllegro::EventKeyUp
        keys.released(event.keyboard.keycode)
      when LibAllegro::EventDisplayClose
        @exit = true
      end
    end

    def check_scenes
      @exit = true if mainMenu.exit?

      # if (scene == &gameScene)
      #   if (gameScene.isExit)
      #     switchScene(&mainMenu);
    end

    def update(keys : Keys, mouse : Mouse)
      scene.update(keys, mouse)
    end

    def draw
      # scene.draw
    end

    def reset
      super

      @redraw = false
    end

    def destroy
      # scene.destroy
    end
  end
end
