require "./animations"
require "./animation"
require "./timer"
require "./inventory"
require "./keys"
require "./mouse"
require "./map"
require "./tile/ore/base"
require "./cell"
require "./hud_text"
require "./ui/progress_bar"

module Works
  class Player
    MiningDistance = 64
    MiningInterval = 500.milliseconds
    MiningAmount = 10

    property x
    property y
    property speed
    property animations
    getter inventory
    getter ore_hover : Tile::Ore::Base | Nil
    getter mining_timer
    getter struct_hover : Struct::Base | Nil

    def initialize
      @y = 0
      @x = 0
      @speed = 0
      @animations = Animations.new
      @inventory = Inventory.new
      @ore_hover = nil
      @mining_timer = Timer.new(MiningInterval)
      @struct_hover = nil
    end

    def init(sheet : LibAllegro::Bitmap)
      init_animations(sheet)
      inventory.init
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
      mouse_col, mouse_row = mouse.to_map_coords(map.x, map.y)

      update_movement(keys)
      update_mining(map, mouse, mouse_col, mouse_row)
      update_structs(map, mouse, mouse_col, mouse_row)
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

    def update_mining(map : Map, mouse : Mouse, mouse_col, mouse_row)
      @ore_hover = map.ore.find(&.hover?(mouse_col, mouse_row))

      return unless ore = @ore_hover
      return unless distance(ore) < MiningDistance
      unless mouse.right_pressed?
        @mining_timer.stop
        return
      end

      mining_timer.start unless mining_timer.started?

      return unless mining_timer.done?

      amount = inventory.amount_can_add(ore.item_class, ore.mine_amount(MiningAmount))

      if amount > 0
        inventory.add(ore.item_class, ore.mine(amount))
      end

      mining_timer.restart
    end

    def update_structs(map : Map, mouse : Mouse, mouse_col, mouse_row)
      @struct_hover = map.structs.find(&.hover?(mouse_col, mouse_row))

      return unless strct = @struct_hover
      return unless distance(strct) < MiningDistance
      return unless mouse.right_pressed?

      amount = inventory.amount_can_add(strct.item_class, 1)

      if amount > 0
        if removed = map.structs.delete(struct_hover)
          inventory.add(strct.item_class, 1)
        end
      end
    end

    def update_inventory(keys : Keys, mouse : Mouse)
      if keys.just_pressed?(LibAllegro::KeyI)
        inventory.show_toggle
      end
    end

    def distance(cell : Cell)
      player_x = x
      player_y = y
      cell_x = cell.x + cell.width / 2
      cell_y = cell.y + cell.height / 2

      dx = player_x - cell_x
      dy = player_y - cell_y

      Math.sqrt(dx * dx + dy * dy).to_i
    end

    def draw(x, y)
      if ore_hover = @ore_hover
        ore_hover.draw_hover(x, y)
      end

      if struct_hover = @struct_hover
        struct_hover.draw_hover(x, y)
      end

      animations.draw(x + @x, y + @y)

      if ore_hover = @ore_hover
        if mining_timer.started?
          UI::ProgressBar.new(width, 5, mining_timer.percent).draw_from_bottom(x + @x - width / 2, y + @y - height / 2)
        end
      end

      inventory.draw(x, y)
    end

    def destroy
      animations.destroy
    end
  end
end
