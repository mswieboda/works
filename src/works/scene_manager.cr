require "./scene"
require "./keys"
require "./mouse"
require "./main_menu"
require "./game_scene"

module Works
  class SceneManager < Scene
    property? redraw
    property keys
    property mouse
    property scene : Scene

    property mainMenu
    property gameScene

    def initialize(screen_width, screen_height)
      super(screen_width, screen_height)

      @redraw = false

      @keys = Keys.new
      @mouse = Mouse.new

      @mainMenu = MainMenu.new(screen_width, screen_height)
      @gameScene = GameScene.new(screen_width, screen_height)

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
    end

    def reset
      super

      @redraw = false
    end

    def destroy
      scene.destroy
    end
  end
end
