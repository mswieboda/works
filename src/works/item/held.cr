require "../mouse"

module Works::Item
  class Held
    getter x : Int32
    getter y : Int32
    getter item : Item::Base
    getter size : Int32

    def initialize(x, y, item, size)
      @x = x
      @y = y
      @item = item
      @size = size
    end

    def update(mouse : Mouse)
      @x = mouse.x
      @y = mouse.y
    end

    def draw
      item.draw(x, y, size)
    end
  end
end
