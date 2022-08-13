require "./ground"
require "./coal"
require "./tile"
require "./mouse"

module Works
  class Map
    getter x
    getter y
    getter width
    getter height
    getter ground
    getter coal
    getter coal_hover : Coal | Nil

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Ground
      @coal = [] of Coal
    end

    def draw
      ground.each(&.draw(x, y))
      coal.each(&.draw(x, y))
    end

    def destroy
      ground.each(&.destroy)
      coal.each(&.destroy)
    end
  end
end
