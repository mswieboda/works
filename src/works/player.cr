require "./animations"
require "./animation"
require "./timer"
require "./inventory"
require "./keys"
require "./mouse"
require "./map"
require "./tile/base"
require "./tile/ore/base"
require "./hud_text"

module Works
  class Player
    MiningDistance = 64
    MiningInterval = 500.milliseconds
    MiningAmount = 10

    property x
    property y
    property speed
    property animations
    getter ore_hover : Tile::Ore::Base | Nil
    getter mining_timer
    getter inventory

    def initialize
      @y = 0
      @x = 0
      @speed = 0
      @animations = Animations.new
      @ore_hover = nil
      @mining_timer = Timer.new(MiningInterval)
      @inventory = Inventory.new
    end

    def init_animations(sheet : LibAllegro::Bitmap)
      idle = Animation.new((Screen::FPS / 3).to_i)
      size = 64
      idle_frames = 5

      idle_frames.times do |i|
        idle.add(sheet, i * size, 0, size, size)
      end

      idle_walk_left = Animation.new((Screen::FPS / 3).to_i)
      idle_walk_left_frames = 4

      idle_walk_left_frames.times do |i|
        i += idle_frames
        idle_walk_left.add(sheet, i * size, 0, size, size)
      end

      animations.add(idle, :idle)
      animations.add(idle_walk_left, :idle_walk_left)
      animations.play(:idle)
    end

    def width
      48 # temp until calc'ed from sprite
    end

    def height
      64 # temp until calc'ed from sprite
    end

    def update(keys : Keys, mouse : Mouse, map : Map)
      update_movement(keys)
      update_mining(mouse, map)
      update_inventory(keys, mouse)

      animations.update
    end

    def update_movement(keys : Keys)
      dx = 0
      dy = 0

      dy -= speed if keys.pressed?([LibAllegro::KeyUp, LibAllegro::KeyW])
      dy += speed if keys.pressed?([LibAllegro::KeyDown, LibAllegro::KeyS])

      if keys.pressed?([LibAllegro::KeyLeft, LibAllegro::KeyA])
        dx -= speed
        animations.play(:idle_walk_left)
      end

      dx += speed if keys.pressed?([LibAllegro::KeyRight, LibAllegro::KeyD])

      if dx == 0 && dy == 0
        animations.play(:idle)
      else
        @x += dx
        @y += dy
      end
    end

    def update_mining(mouse : Mouse, map : Map)
      mx, my = mouse.to_map_coords(map.x, map.y)

      row = (my / Tile::Ore::Base.size).to_u16
      col = (mx / Tile::Ore::Base.size).to_u16

      @ore_hover = map.ore.find { |c| c.row == row && c.col == col }

      return unless ore = @ore_hover
      return unless distance(ore) < MiningDistance
      return unless mouse.right_pressed?

      mining_timer.start unless mining_timer.started?

      return unless mining_timer.done?

      amount = inventory.amount_can_add(ore.item_class, ore.mine_amount(MiningAmount))

      if amount > 0
        inventory.add(ore.item_class, ore.mine(amount))
      end

      mining_timer.restart
    end

    def update_inventory(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyI)
        inventory.show_toggle
      end
    end

    def distance(tile : Tile::Base)
      player_x = x
      player_y = y
      tile_x = tile.x + tile.width / 2
      tile_y = tile.y + tile.height / 2

      dx = player_x - tile_x
      dy = player_y - tile_y

      Math.sqrt(dx * dx + dy * dy).to_i
    end

    def draw(x, y)
      if ore_hover = @ore_hover
        ore_hover.draw_hover(x, y)
      end

      animations.draw(x + @x, y + @y)

      inventory.draw(x, y)
    end

    def destroy
      animations.destroy
    end
  end
end
