module Works::Item
  abstract class Base
    MaxAmount = 100
    IconTextColor = LibAllegro.map_rgba_f(0.5, 0.5, 0.5, 0.5)

    getter key
    getter name
    getter amount

    def initialize(key = :base, name = "")
      @key = key
      @name = name
      @amount = 0
    end

    def self.key
      :base
    end

    def self.max_amount
      MaxAmount
    end

    def max_amount
      self.class.max_amount
    end

    def full?
      amount >= max_amount
    end

    def add(amount)
      total = @amount + amount

      if total > max_amount
        @amount = max_amount
      else
        @amount += amount
      end

      total - @amount
    end

    def draw(x, y, size)
      draw_icon(x, y, size)
      draw_icon_text(x, y, size)
    end

    def draw_icon_text(x, y, size)
      LibAllegro.draw_text(Font.default, IconTextColor, x + size, y + size - size / 3, LibAllegro::AlignRight, @amount.to_s)
    end

    abstract def draw_icon(x, y, size)

    def print_str
      "#{name}: #{amount}"
    end
  end
end
