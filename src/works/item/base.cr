require "../font"

module Works::Item
  abstract class Base
    Key = :base
    Name = "Item"
    ShortCode = "IB"
    MaxAmount = 100
    IconTextColor = LibAllegro.premul_rgba_f(1, 1, 1, 0.5)
    Color = LibAllegro.map_rgb_f(1, 0, 1)
    ItemSize = Cell.size / 2
    IconMargin = 4 * Screen.scale_factor

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

    def self.icon_color
      Color
    end

    def icon_color
      self.class.icon_color
    end

    def clone
      item = self.class.new
      item.amount = @amount
      item
    end

    def full?
      amount >= max_amount
    end

    def none?
      amount <= 0
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

    def remove(amount)
      if amount > @amount
        pre_amount = @amount
        @amount = 0

        amount - pre_amount
      else
        @amount -= amount

        0
      end
    end

    def remove_as_new(amount)
      item = self.class.new

      leftovers = remove(amount)

      item.add(amount - leftovers)

      item
    end

    def draw_icon(x, y, size)
      draw_icon_background(x, y, size)
      draw_icon_text(x, y, size)
    end

    def draw_icon_background(x, y, size)
      size -= IconMargin * 2

      LibAllegro.draw_filled_circle(x + IconMargin + size / 2, y + IconMargin + size / 2, size / 2, icon_color)
    end

    def draw_icon_text(x, y, size)
      size -= IconMargin * 2

      LibAllegro.draw_text(Font.default, IconTextColor, x + size / 6, y + size / 5, 0, short_code)
      LibAllegro.draw_text(Font.default, IconTextColor, x + size, y + size - size / 3, LibAllegro::AlignRight, @amount.to_s)
    end

    def draw_item(cx, cy)
      x = cx - ItemSize / 2
      y = cy - ItemSize / 2

      LibAllegro.draw_filled_rectangle(x, y, x + ItemSize, y + ItemSize, icon_color)
    end

    def print_str
      "#{name}: #{amount}"
    end
  end
end
