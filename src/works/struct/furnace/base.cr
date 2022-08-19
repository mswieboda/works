require "../base"

module Works::Struct::Furnace
  abstract class Base < Struct::Base
    Key = :furnace
    Name = "furnace"
    Dimensions = {x: 2, y: 2}
    Color = LibAllegro.map_rgb_f(0.5, 0.5, 0.1)

    property input_item : Item::Base | Nil
    property output_item : Item::Base | Nil
    property fuel_item : Item::Base | Nil
    getter working_item : Item::Base | Nil
    getter output_timer

    def initialize(col = 0_u16, row = 0_u16)
      super(col, row)

      @input_item = nil
      @output_item = nil
      @fuel_item = nil
      @output_timer = Timer.new(0.seconds)
      @working_item = nil
    end

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.dimensions
      Dimensions
    end

    def self.color
      Color
    end

    def item_class
      case key
      when :stone_furnace
        Item::Struct::Furnace::Stone
      when :electric_furnace
        Item::Struct::Furnace::Electric
      else
        Item::Struct::Furnace::Base
      end
    end

    def update
      if input = input_item
        if output = output_item
          return if output.full?
        end

        update_output(input)
      end
    end

    def update_output(item : Item::Base)
      duration = output_duration(item)

      if @output_timer.duration != duration
        @output_timer.stop
        @output_timer.duration = duration
        @output_timer.start
      end

      burn_item(item) unless @working_item

      if @output_timer.done?
        if working = @working_item
          create_output(working)

          @output_timer.restart
        end
      end
    end

    def burn_item(item : Item::Base)
      klass = case item
      # when Item::Ore::Copper
      #   Item::CopperPlate
      when Item::Ore::Iron
        Item::IronPlate
      # when Item::Ore::Stone
      #   Item::StoneBrick
      # when Item::IronPlate
      #   Item::SteelPlate
      else
        Item::Base
      end

      amount = case item
      when Item::Ore::Copper, Item::Ore::Iron
        1
      # when Item::Ore::Stone
      #   2
      # when Item::IronPlate
      #   5
      else
        1
      end

      working = klass.new

      item.remove(amount)
      working.add(1)

      @working_item = working

      if item.none?
        @input_item = nil
      end
    end

    def create_output(working_item : Item::Base)
      if output = output_item
        if output.class == working_item.class
          amount = working_item.amount
          leftovers = output.add(amount)

          if leftovers > 0
            working_item.remove(amount - leftovers)
          else
            @working_item = nil
          end
        end
      else
        @output_item = working_item
        @working_item = nil
      end
    end

    abstract def output_duration(item : Item::Base) : Time::Span
  end
end
