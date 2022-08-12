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

      @font = LibAllegro.create_builtin_font

      @time_start = Time.local
      @time_end = Time.local
      @frames = 0
      @str_fps = ""
      @str_time = ""
      @fps_percent = 0.0
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

      draw_fps
    end

    def reset
      super

      @redraw = false
    end

    def destroy
      scene.destroy
    end

    def calc_fps
      @time_end = Time.local
      time = @time_end - @time_start
      fps = (@frames + 1) / time.total_seconds
      @str_fps = "#{fps.round(2)}"
      @str_time = "#{time.total_seconds.round(1)}s"
      @fps_percent = time.total_seconds / 10 * 100
      @frames += 1

      if time.total_seconds >= 10
        @time_start = Time.local
        @frames = 0
      end
    end

    def draw_fps
      dark = LibAllegro.map_rgba_f(0, 0, 0, 0.69)
      green = LibAllegro.map_rgba_f(0, 1, 0, 0.69)

      LibAllegro.draw_filled_rectangle(3, 3, 107, 22, dark)
      LibAllegro.draw_text(@font, green, 9, 5, LibAllegro::AlignInteger, @str_fps)
      LibAllegro.draw_text(@font, green, 101, 5, LibAllegro::AlignRight, @str_time)
      LibAllegro.draw_filled_rectangle(5, 15, 5 + @fps_percent, 20, green)
    end
  end
end
