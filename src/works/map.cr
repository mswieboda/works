require "./ground"
require "./coal"
require "./tile"
require "./mouse"
require "./map_hud"

module Works
  class Map
    getter x
    getter y
    getter width
    getter height
    getter ground
    getter coal
    getter screen_width : Int32
    getter screen_height : Int32

    @coal_hover : Coal | Nil

    def initialize(screen_width, screen_height)
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Ground
      @coal = [] of Coal
      @coal_hover = nil
      @screen_width = screen_width
      @screen_height = screen_height
    end

    def update(mouse : Mouse)
      @coal_hover = nil

      map_mouse = Mouse.new((mouse.x - x).clamp(0, nil), (mouse.y - y).clamp(0, nil))

      row = (map_mouse.y / Coal.size).to_u16
      col = (map_mouse.x / Coal.size).to_u16

      @coal_hover = coal.find { |c| c.row == row && c.col == col }
    end

    def draw
      ground.each(&.draw(x, y))
      coal.each(&.draw(x, y))

      if coal_hover = @coal_hover
        coal_hover.draw_hover(x, y)
        MapHUD.new("coal: #{coal_hover.amount}").draw_from_bottom(0, screen_height)
      end
    end

    def destroy
      ground.each(&.destroy)
      coal.each(&.destroy)
    end
  end
end
