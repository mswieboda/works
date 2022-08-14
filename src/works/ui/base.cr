module Works::UI
  abstract class Base
    property width : Int32
    property height : Int32
    property margin : Int32
    property padding : Int32

    def initialize(width, height, margin = 0, padding = 0)
      @width = width
      @height = height
      @margin = margin
      @padding = padding
    end

    def inner_height
      padding * 2 + height
    end

    def outer_height
      margin * 2 + inner_height
    end

    def inner_width
      padding * 2 + width
    end

    def outer_width
      margin * 2 + inner_width
    end

    abstract def draw(x, y)
  end
end
