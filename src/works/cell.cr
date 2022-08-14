module Works
  class Cell
    SelectionLength = 10
    SelectionThickness = 3

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

    def draw_selection(dx, dy, selection_color = nil)
      dx += x
      dy += y

      color = selection_color || LibAllegro.premul_rgba_f(1, 1, 1, 0.69)
      other = LibAllegro.map_rgb_f(1, 0, 1)

      # top left
      LibAllegro.draw_line(dx - SelectionThickness / 2, dy, dx + SelectionLength, dy, color, SelectionThickness)
      LibAllegro.draw_line(dx, dy, dx, dy + SelectionLength, color, SelectionThickness)

      # top right
      LibAllegro.draw_line(dx + width - SelectionLength, dy, dx + width + SelectionThickness / 2, dy, color, SelectionThickness)
      LibAllegro.draw_line(dx + width, dy, dx + width, dy + SelectionLength, color, SelectionThickness)

      # bottom left
      LibAllegro.draw_line(dx - SelectionThickness / 2, dy + height, dx + SelectionLength, dy + height, color, SelectionThickness)
      LibAllegro.draw_line(dx, dy + height, dx, dy + height - SelectionLength, color, SelectionThickness)

      # bottom right
      LibAllegro.draw_line(dx + width - SelectionLength, dy + height, dx + width + SelectionThickness / 2, dy + height, color, SelectionThickness)
      LibAllegro.draw_line(dx + width, dy + height, dx + width, dy + height - SelectionLength, color, SelectionThickness)
    end

    def print_str
      "> #{name} (#{col}, #{row})"
    end
  end
end
