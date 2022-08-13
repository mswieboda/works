require "./scene"
require "./map"
require "./player"

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

    def initialize(screen_width, screen_height)
      super(screen_width, screen_height)

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
      (screen_width / Ground.size).to_u16.times do |col|
        (screen_height / Ground.size).to_u16.times do |row|
          map.ground << Ground.new(row, col)
        end
      end

      # coal patches
      [
        [3_u16, 3_u16, 3_u16, 3_u16],
        [17_u16, 13_u16, 1_u16, 1_u16],
        [15_u16, 1_u16, 5_u16, 5_u16]
      ].each do |data|
        init_rows, init_cols, rows, cols = data
        rows += init_rows
        cols += init_cols

        (init_rows...rows).to_a.each do |row|
          (init_cols...cols).to_a.each do |col|
            map.coal << Coal.new(row, col, rand(UInt16::MAX))
          end
        end
      end
    end

    def init_player
      @player.x = 100
      @player.y = 100
      @player.speed = 5

      player.init_animations(sheet)
    end

    def update(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyEscape)
        @exit = true
        return
      end

      map.update(mouse)
      player.update(keys)
    end

    def draw
      map.draw
      player.draw(0, 0)
    end

    def destroy
      map.destroy
      player.destroy
      LibAllegro.destroy_bitmap(sheet)
    end
  end
end
