require "./ground"
require "./coal"
require "./tile"
require "./mouse"

module Works
  class Map
    property x
    property y
    property width
    property height
    property ground
    property coal

    @coal_hover : Coal | Nil

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Ground
      @coal = [] of Coal
      @coal_hover = nil
    end

    def update(mouse : Mouse)
      @coal_hover = nil

      map_mouse = Mouse.new(mouse.x - x, mouse.y - y)

      row = (map_mouse.y / Coal.size).to_u16
      col = (map_mouse.x / Coal.size).to_u16

      @coal_hover = coal.find { |c| c.row == row && c.col == col }
    end

    def draw
      ground.each(&.draw(x, y))
      coal.each(&.draw(x, y))

      if coal_hover = @coal_hover
        coal_hover.draw_hover(x, y)
      end
    end

    def destroy
      ground.each(&.destroy)
      coal.each(&.destroy)
    end
  end
end
