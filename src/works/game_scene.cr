require "./scene"
require "./map"
require "./player"
require "./tile/grass"
require "./tile/ore/coal"
require "./tile/ore/iron"
require "./tile/ore/copper"
require "./tile/ore/stone"
require "./struct/stone_furnace"

module Works
  class GameScene < Scene
    property map
    property player
    property sheet

    def initialize
      super

      @name = :game_scene
      @map = Map.new
      @player = Player.new
      @sheet = LibAllegro.load_bitmap("./assets/player.png")
    end

    def init
      init_map
      init_player
    end

    def init_map
      # ground
      (Screen::Width / Tile::Grass.size).to_u16.times do |col|
        (Screen::Height / Tile::Grass.size).to_u16.times do |row|
          map.ground << Tile::Grass.new(col, row)
        end
      end

      # coal patches
      [
        [3_u16, 3_u16, 3_u16, 3_u16],
        [13_u16, 17_u16, 1_u16, 1_u16],
        [1_u16, 15_u16, 5_u16, 5_u16]
      ].each do |data|
        add_ore(Tile::Ore::Coal, data)
      end

      # iron patches
      [
        [6_u16, 7_u16, 2_u16, 2_u16],
        [17_u16, 21_u16, 1_u16, 1_u16]
      ].each do |data|
        add_ore(Tile::Ore::Iron, data)
      end

      # copper patches
      [
        [10_u16, 9_u16, 2_u16, 3_u16],
        [2_u16, 7_u16, 1_u16, 1_u16]
      ].each do |data|
        add_ore(Tile::Ore::Copper, data)
      end

      # stone patches
      [
        [13_u16, 1_u16, 3_u16, 2_u16],
        [1_u16, 9_u16, 1_u16, 1_u16]
      ].each do |data|
        add_ore(Tile::Ore::Stone, data)
      end

      # NOTE: *** TEMP stone furnace ***
      map.structs << Struct::StoneFurnace.new(7, 3)
    end

    def add_ore(klass, data)
      init_cols, init_rows, cols, rows = data
      cols += init_cols
      rows += init_rows

      (init_cols...cols).to_a.each do |col|
        (init_rows...rows).to_a.each do |row|
          map.ore << klass.new(col, row, rand(3_000_u16))
        end
      end
    end

    def init_player
      @player.x = 100
      @player.y = 100
      @player.speed = 5

      player.init(sheet)
    end

    def update(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyEscape)
        @exit = true
        return
      end

      player.update(keys, mouse, map)
    end

    def draw
      map.draw
      player.draw(map.x, map.y)

      if ore_hover = player.ore_hover
        HUDText.new("#{ore_hover.name}: #{ore_hover.amount}").draw_from_bottom(0, Screen::Height)
      end
    end

    def destroy
      map.destroy
      player.destroy
      LibAllegro.destroy_bitmap(sheet)
    end
  end
end
