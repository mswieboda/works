module Works
  class Cell
    Size = 32_u8
    Dimensions = {x: 1, y: 1}

    property col : UInt16
    property row : UInt16

    def initialize(col = 0_u16, row = 0_u16)
      @col = col
      @row = row
    end

    def name
      self.class.name
    end

    def self.dimensions
      Dimensions
    end

    def dimensions
      self.class.dimensions
    end

    def self.size
      Size
    end

    def size
      self.class.size
    end

    def width
      size * dimensions[:x]
    end

    def height
      size * dimensions[:y]
    end

    def x
      col * size
    end

    def y
      row * size
    end

    def hover?(mouse_col, mouse_row)
      mouse_col >= col && mouse_col < col + dimensions[:x] &&
        mouse_row >= row && mouse_row < row + dimensions[:y]
    end

    def print_str
      "> #{name} (#{col}, #{row})"
    end
  end
end
