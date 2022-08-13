module Works::Item
  class Coal < Base
    MaxAmount = 50
    IconColor = LibAllegro.map_rgba_f(0, 0, 0, 0.777)

    def initialize(key = :coal, name = "Coal")
      super(key, name)
    end

    def self.max_amount
      MaxAmount
    end

    def self.key
      :coal
    end

    def clone
      item = self.class.new
      item.amount = @amount
      item
    end

    def draw_icon(x, y, size)
      LibAllegro.draw_filled_circle(x + size / 2, y + size / 2, size / 2, IconColor)
      LibAllegro.draw_text(Font.default, IconTextColor, x + size / 5, y + size / 5, 0, "c")
    end
  end
end
