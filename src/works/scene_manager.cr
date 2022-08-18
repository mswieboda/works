require "./scene"
require "./keys"
require "./mouse"
require "./fps_display"
require "./main_menu"
require "./game_scene"

module Works
  class SceneManager < Scene
    property? redraw
    property keys
    property mouse
    property fps

    property scene : Scene
    property mainMenu
    property gameScene

    def initialize
      super

      @redraw = false

      @keys = Keys.new
      @mouse = Mouse.new
      @fps = FPSDisplay.new

      @mainMenu = MainMenu.new
      @gameScene = GameScene.new

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
        mouse.reset

        calc_fps

        @redraw = true
      when LibAllegro::EventMouseAxes
        # TODO: make a mouse input holder, similar to Keys
        #       then put both Keys and Mouse inside Input ?
        mouse.x = event.mouse.x
        mouse.y = event.mouse.y
      when LibAllegro::EventKeyDown
        keys.pressed(event.keyboard.keycode)
      when LibAllegro::EventKeyUp
        keys.released(event.keyboard.keycode)
      when LibAllegro::EventMouseButtonDown
        mouse.pressed(event.mouse.button)
      when LibAllegro::EventMouseButtonUp
        mouse.released(event.mouse.button)
      when LibAllegro::EventDisplayClose
        @exit = true
      end
    end

    def check_scenes
      case scene.name
      when :main_menu
        @exit = true if mainMenu.exit?
        switch(gameScene) if mainMenu.start?
      when :game_scene
        switch(mainMenu) if gameScene.exit?
      end
    end

    def switch(nextScene : Scene)
      scene.reset

      @scene = nextScene

      scene.init
    end

    def update(keys : Keys, mouse : Mouse)
      scene.update(keys, mouse)
    end

    def draw
      scene.draw
      fps.draw
    end

    def destroy
      scene.destroy
    end

    def calc_fps
      fps.calc
    end
  end
end
