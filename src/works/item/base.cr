module Works::Item
  abstract class Base
    Key = :base
    Name = "Item"
    ShortCode = "IB"
    MaxAmount = 100
    IconTextColor = LibAllegro.map_rgba_f(0.5, 0.5, 0.5, 0.5)

    getter amount
    protected setter amount

    def initialize
      @amount = 0
    end

    def self.key
      Key
    end

    def key
      self.class.key
    end

    def self.name
      Name
    end

    def name
      self.class.name
    end

    def self.short_code
      ShortCode
    end

    def short_code
      self.class.short_code
    end

    def self.max_amount
      MaxAmount
    end

    def max_amount
      self.class.max_amount
    end

    def clone
      item = self.class.new
      item.amount = @amount
      item
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
      LibAllegro.draw_text(Font.default, IconTextColor, x + size / 6, y + size / 5, 0, short_code)
      LibAllegro.draw_text(Font.default, IconTextColor, x + size, y + size - size / 3, LibAllegro::AlignRight, @amount.to_s)
    end

    abstract def draw_icon(x, y, size)

    def print_str
      "#{name}: #{amount}"
    end
  end
end
