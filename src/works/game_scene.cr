require "./scene"

module Works
  class GameScene < Scene
    # property map
    # property player
    property sheet

    def initialize
      super

      @name = :game_scene
      @sheet = LibAllegro.load_bitmap("./assets/player.png")
    end

    def init
      init_map
      init_player
    end

    def init_map
    end

    def init_player
    end

    def update(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyEscape)
        @exit = true
        return
      end

      # map.update(mouse)
      # player.update(keys)
    end

    def draw
      # map.draw
      # player.draw(0, 0)
    end

    def destroy
      # player.destroy
      LibAllegro.destroy_bitmap(sheet)
    end
  end
end
