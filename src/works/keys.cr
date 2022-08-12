module Works
  class Keys
    KeySeen = 1
    KeyReleased = 2
    KeyPressed = 3

    property keys

    def initialize
      @keys = Array(Int64).new(LibAllegro::KeyMax, 0)
    end

    def reset
      keys.each_with_index do |key, index|
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
      keys[keycode] > 0
    end

    def any_pressed?(keycodes : Array(Int))
      keycodes.any? { |keycode| pressed?(keycode) }
    end

    def just_pressed?(keycode : Int)
      @keys[keycode] == KeyPressed
    end

    def any_just_pressed?(keycodes : Array(Int))
      keycodes.any? { |keycode| just_pressed?(keycode) }
    end
  end
end
