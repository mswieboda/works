module Works
  class Mouse
    enum Button
      Left = 1
      Right
      Middle
      Four
      Five
    end

    None = 0_u8
    Seen = 1_u8
    Released = 2_u8
    Pressed = 3_u8

    property x
    property y

    def initialize(x = 0, y = 0)
      @x = x
      @y = y
      @buttons = Array(UInt8).new(Button.values.size, 0)
    end

    def to_xy(x, y)
      [
        (@x - x).clamp(0, nil),
        (@y - y).clamp(0, nil)
      ]
    end

    def to_map_coords(x, y)
      to_xy(x, y).map { |v| (v / Cell.size).to_u16 }
    end

    def reset
      @buttons.each_with_index do |key, index|
        @buttons[index] &= Seen
      end
    end

    def pressed(button : Int)
      @buttons[button] = Pressed
    end

    def released(button : Int)
      @buttons[button] &= Released
    end

    def pressed?(button : Int)
      @buttons[button] > None
    end

    def just_pressed?(button : Int)
      @buttons[button] == Pressed
    end

    def left_pressed?
      pressed?(Button::Left.value)
    end

    def right_pressed?
      pressed?(Button::Right.value)
    end

    def left_just_pressed?
      just_pressed?(Button::Left.value)
    end

    def right_just_pressed?
      just_pressed?(Button::Right.value)
    end
  end
end
