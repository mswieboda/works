module Works
  class Mouse
    property x
    property y

    def initialize
      @x = 0
      @y = 0
    end

    def initialize(x, y)
      @x = x
      @y = y
    end
  end
end
