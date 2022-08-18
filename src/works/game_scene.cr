require "./scene"
require "./map"
require "./player"
require "./tile/grass"
require "./tile/ore/coal"
require "./tile/ore/iron"
require "./tile/ore/copper"
require "./tile/ore/stone"

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
      map_cols = 500
      map_rows = 500

      # ground
      map_cols.to_u16.times do |col|
        map.ground << [] of Tile::Base

        map_rows.to_u16.times do |row|
          map.ground[col] << Tile::Grass.new(col, row)
        end
      end

      # nil ore
      map_cols.to_u16.times do |col|
        map.ore << [] of Tile::Ore::Base | Nil

        map_rows.to_u16.times do |row|
          map.ore[col] << nil
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
    end

    def add_ore(klass, data)
      init_cols, init_rows, cols, rows = data
      cols += init_cols
      rows += init_rows

      (init_cols...cols).to_a.each do |col|
        (init_rows...rows).to_a.each do |row|
          map.ore[col][row] = klass.new(col, row, rand(3_000_u16))
        end
      end
    end

    def init_player
      player.x = 333
      player.y = 333
      player.speed = 5

      player.init(sheet)
    end

    def update(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyEscape)
        @exit = true
        return
      end

      player.update(keys, mouse, map)
      map.update_viewport(player.x, player.y)
      map.update
    end

    def draw
      map.draw
      player.draw(map.x, map.y)

      draw_hover_info
    end

    def draw_hover_info
      if ore_hover = player.ore_hover
        ore_hover.draw_hover_info
      end

      if struct_hover = player.struct_hover
        struct_hover.draw_hover_info
      end

      if (held_item = player.inventory.held_item) && !player.inventory.hud.hover?
        if strct = held_item.strct
          strct.draw_hover_info
        end
      end
    end

    def destroy
      map.destroy
      player.destroy
      LibAllegro.destroy_bitmap(sheet)
    end
  end
end
