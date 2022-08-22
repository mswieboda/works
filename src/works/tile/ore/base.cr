require "../base"
require "../../item/ore/base"

module Works::Tile::Ore
  abstract class Base < Tile::Base
    Name = "Ore"
    Color = LibAllegro.premul_rgba_f(1, 0, 1, 0.69)

    getter amount : UInt16

    def initialize(col = 0_u16, row = 0_u16, amount = 0_u16)
      super(col, row)

      @amount = amount
    end

    def self.name
      Name
    end

    def self.item_class
      Item::Ore::Base
    end

    def item_class
      self.class.item_class
    end

    def self.color
      Color
    end

    def color
      self.class.color
    end

    def draw_hover(dx, dy)
      draw_selection(dx, dy)
    end

    def draw_hover_info
      HUDText.new("#{name}: #{amount}").draw_from_bottom(0, Screen.height)
    end

    def print_str
      "#{super} a: #{amount}"
    end

    def mine_amount(amount)
      @amount < amount ? @amount : amount
    end

    def mine(amount)
      removed = mine_amount(amount)

      @amount -= removed

      removed
    end
  end
end
