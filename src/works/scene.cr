module Works
  abstract class Scene
    property name
    property? exit
    property screen_width
    property screen_height

    def initialize
      @name = :scene
      @exit = false
      @screen_width = 1
      @screen_height = 1
    end

    def initialize(screen_width, screen_height)
      @name = :scene
      @exit = false
      @screen_width = screen_width
      @screen_height = screen_height
    end

    abstract def init

    abstract def update(keys : Keys, mouse : Mouse)

    abstract def draw

    def reset
      @exit = false
    end

    abstract def destroy
  end
end
