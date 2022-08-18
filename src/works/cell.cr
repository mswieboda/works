module Works
  abstract class Cell
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

    def clone
      self.class.new(col, row)
    end

    def cols
      dimensions[:x]
    end

    def rows
      dimensions[:y]
    end

    def width
      size * cols
    end

    def height
      size * rows
    end

    def x
      col * size
    end

    def y
      row * size
    end

    def overlaps?(cell : Cell)
      col < cell.col + cell.cols && cell.col < col + cols &&
        row < cell.row + cell.rows && cell.row < row + rows
    end

    def hover?(mouse_col, mouse_row)
      mouse_col >= col && mouse_col < col + dimensions[:x] &&
        mouse_row >= row && mouse_row < row + dimensions[:y]
    end

    abstract def draw(x, y)

    def draw_selection(dx, dy, color = nil)
      self.class.draw_selection(dx + x, dy + y, width, height, color)
    end

    def self.draw_selection(x, y, width, height, selection_color = nil)
      color = selection_color || LibAllegro.premul_rgba_f(1, 1, 1, 0.69)

      # top left
      LibAllegro.draw_line(x - SelectionThickness / 2, y, x + SelectionLength, y, color, SelectionThickness)
      LibAllegro.draw_line(x, y, x, y + SelectionLength, color, SelectionThickness)

      # top right
      LibAllegro.draw_line(x + width - SelectionLength, y, x + width + SelectionThickness / 2, y, color, SelectionThickness)
      LibAllegro.draw_line(x + width, y, x + width, y + SelectionLength, color, SelectionThickness)

      # bottom left
      LibAllegro.draw_line(x - SelectionThickness / 2, y + height, x + SelectionLength, y + height, color, SelectionThickness)
      LibAllegro.draw_line(x, y + height, x, y + height - SelectionLength, color, SelectionThickness)

      # bottom right
      LibAllegro.draw_line(x + width - SelectionLength, y + height, x + width + SelectionThickness / 2, y + height, color, SelectionThickness)
      LibAllegro.draw_line(x + width, y + height, x + width, y + height - SelectionLength, color, SelectionThickness)
    end

    def print_str
      "> #{name} (#{col}, #{row})"
    end
  end
end
