require "../base"

module Works::Struct::Inserter
  abstract class Base < Struct::Base
    Key = :inserter
    Name = "inserter"
    Color = LibAllegro.map_rgb_f(1, 0, 1)

    property item : Item::Base | Nil

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @item = nil
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def item_class
      case key
      when :burner_inserter
        Item::Struct::Inserter::Burner
      else
        raise "#{self.class.name}#item_class item not found for #{key}"
      end
    end

    def accept_input?(item : Item::Base)
      true
    end

    def update

    end
  end
end
