module Works
  class Keys
    KeySeen = 1_u8
    KeyReleased = 2_u8
    KeyPressed = 3_u8

    def initialize
      @keys = Array(UInt8).new(LibAllegro::KeyMax, 0_u8)
    end

    def reset
      @keys.each_with_index do |key, index|
        @keys[index] &= KeySeen
      end
    end

    def pressed(keycode : Int)
      @keys[keycode] = KeyPressed
    end

    def released(keycode : Int)
      @keys[keycode] &= KeyReleased
    end

    def pressed?(keycode : Int)
      @keys[keycode] > 0_u8
    end

    def pressed?(keycodes : Array(Int))
      keycodes.any? { |keycode| pressed?(keycode) }
    end

    def any_pressed?
      @keys.any? { |v| v > 0_u8 }
    end

    def just_pressed?(keycode : Int)
      @keys[keycode] == KeyPressed
    end

    def just_pressed?(keycodes : Array(Int))
      keycodes.any? { |keycode| just_pressed?(keycode) }
    end

    def any_just_pressed?
      @keys.any? { |v| v == KeyPressed }
    end
  end
end
