module Works
  abstract class Scene
    property? exit

    def initialize
      @exit = false
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
