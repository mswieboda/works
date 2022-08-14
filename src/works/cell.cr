module Works
  class Cell
    Size = 32_u8
    Dimensions = {x: 1, y: 1}

    property row : UInt16
    property col : UInt16

    def initialize(row = 0_u16, col = 0_u16)
      @row = row
      @col = col
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

    def hover?(mouse_row, mouse_col)
      row == mouse_row && col == mouse_col
    end

    def print_str
      "> #{name} (#{row}, #{col})"
    end
  end
end
