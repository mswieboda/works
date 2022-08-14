require "./tile/base"
require "./tile/ore/base"
require "./struct/base"

module Works
  class Map
    getter x
    getter y
    getter width
    getter height
    getter ground
    getter ore
    getter structs

    def initialize
      @x = 0
      @y = 0
      @width = 0
      @height = 0
      @ground = [] of Tile::Base
      @ore = [] of Tile::Ore::Base
      @structs = [] of Struct::Base
    end

    def draw
      ground.each(&.draw(x, y))
      ore.each(&.draw(x, y))
      structs.each(&.draw(x, y))
    end

    def destroy
      ground.each(&.destroy)
      ore.each(&.destroy)
      structs.each(&.destroy)
    end

    def can_place?(item, mouse_col, mouse_row)
      return false unless item.is_a?(Item::Struct::Base)

      # TODO: impl
      true
    end

    def add_struct(item : Item::Struct::Base, mouse_col, mouse_row)
      puts ">>> place struct item on map! #{item.name} (#{mouse_col}, #{mouse_row})"

      @structs << item.to_struct(mouse_col, mouse_row)
    end
  end
end
