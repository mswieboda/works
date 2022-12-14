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
    MiningDistance = Cell.size.to_i * 4
    MiningInterval = 500.milliseconds
    MiningAmount = 1
    StructRemovalDistance = Cell.size.to_i * 5
    StructRemovalInterval = 1.seconds
    BuildDistance = Cell.size.to_i * 10
    AnimationIdleInterval = 10.seconds

    # HUD
    ProgressBarHeight = 5 * Screen.scale_factor

    property x
    property y
    property speed
    property animations
    getter inventory
    getter ore_hover : Tile::Ore::Base | Nil
    getter mining_timer
    getter struct_hover : Struct::Base | Nil
    getter struct_removal_timer
    getter struct_info : Struct::Base | Nil
    getter idle_timer

    def initialize
      @y = 0
      @x = 0
      @speed = 0
      @animations = Animations.new
      @inventory = Inventory.new
      @ore_hover = nil
      @mining_timer = Timer.new(MiningInterval)
      @struct_hover = nil
      @struct_removal_timer = Timer.new(StructRemovalInterval)
      @struct_info = nil
      @idle_timer = Timer.new(AnimationIdleInterval)
    end

    def init(sheet : LibAllegro::Bitmap)
      init_animations(sheet)
      inventory.init
    end

    def init_animations(sheet : LibAllegro::Bitmap)
      size = 64

      # idle
      idle = Animation.new((Screen.fps / 3).to_i, loops: false)
      idle.add(sheet, 0, 0, size, size)

      # idle animation
      idle_animation_frames = 5
      idle_animation = Animation.new((Screen.fps / 3).to_i, loops: false)

      idle_animation_frames.times do |i|
        idle_animation.add(sheet, i * size, 0, size, size)
      end

      # idle walk left
      idle_walk_left = Animation.new((Screen.fps / 3).to_i)
      idle_walk_left_frames = 4

      idle_walk_left_frames.times do |i|
        i += idle_animation_frames
        idle_walk_left.add(sheet, i * size, 0, size, size)
      end

      animations.add(:idle, idle)
      animations.add(:idle_animation, idle_animation)
      animations.add(:idle_walk_left, idle_walk_left)
      animations.add(:idle_walk_right, idle_walk_left, flip_horizontal: true)
      animations.play(:idle)
    end

    def sprite_width
      # temp until calc'ed from sprite
      64 * Screen.sprite_factor
    end

    def width
      # temp until calc'ed from sprite
      32 * Screen.scale_factor
    end

    def height
      # temp until calc'ed from sprite
      64 * Screen.scale_factor
    end

    def update(keys : Keys, mouse : Mouse, map : Map)
      mouse_col, mouse_row = mouse.to_map_coords(map.x, map.y)

      update_movement(keys)
      update_structs(map, keys, mouse, mouse_col, mouse_row)
      update_struct_info(mouse)
      update_mining(map, mouse, mouse_col, mouse_row)
      update_inventory(keys, mouse, map)

      animations.update
    end

    def update_movement(keys : Keys)
      dx = 0
      dy = 0

      dy -= speed if keys.pressed?([LibAllegro::KeyUp, LibAllegro::KeyW])
      dy += speed if keys.pressed?([LibAllegro::KeyDown, LibAllegro::KeyS])
      dx -= speed if keys.pressed?([LibAllegro::KeyLeft, LibAllegro::KeyA])
      dx += speed if keys.pressed?([LibAllegro::KeyRight, LibAllegro::KeyD])

      if dx == 0 && dy == 0
        idle_timer.start unless idle_timer.started?

        if idle_timer.done?
          animations.play(:idle_animation)
          idle_timer.stop
        elsif animations.done?
          animations.pause
        end
      else
        @x += dx
        @y += dy

        if animations.done?
          animations.play(:idle) if dy != 0
          animations.play(:idle_walk_left) if dx < 0
          animations.play(:idle_walk_right) if dx > 0
        end

        idle_timer.stop if idle_timer.started?
      end
    end

    def update_structs(map : Map, keys : Keys, mouse : Mouse, mouse_col, mouse_row)
      ish = inventory.shown? && inventory.hover?(mouse)
      @struct_hover = ish ? nil : map.structs.find(&.hover?(mouse_col, mouse_row))

      if (strct = @struct_hover)
        if !inventory.held_item && keys.just_pressed?(LibAllegro::KeyR)
          strct.rotate
          strct.after_rotate(map)
        end

        if removable?(strct) && mouse.right_pressed?
          struct_removal_timer.start unless struct_removal_timer.started?

          return unless struct_removal_timer.done?

          amount = inventory.amount_can_add(strct.item_class, 1)

          if amount > 0
            if removed = map.structs.delete(struct_hover)
              inventory.add(strct.item_class, 1)

              if removed.is_a?(Struct::TransportBelt::Base)
                belt = removed.as(Struct::TransportBelt::Base)

                belt.remove_belt_update_turning_belts(map)
              end
            end
          end

          struct_removal_timer.restart
        else
          struct_removal_timer.stop
        end
      else
        struct_removal_timer.stop
      end
    end

    def update_struct_info(mouse : Mouse)
      if mouse.left_just_pressed? && (strct = @struct_hover) && !inventory.held_item
        @struct_info = strct
        mouse.reset
        strct.show_hud
        inventory.show
      end
    end

    def update_mining(map : Map, mouse : Mouse, mouse_col, mouse_row)
      ish = inventory.shown? && inventory.hover?(mouse)
      @ore_hover = @struct_hover || ish ? nil : map.get_ore(mouse_col, mouse_row)

      if (ore = @ore_hover) && minable?(ore) && mouse.right_pressed?
        mining_timer.start unless mining_timer.started?

        return unless mining_timer.done?

        amount = inventory.amount_can_add(ore.item_class, ore.mine_amount(MiningAmount))

        if amount > 0
          inventory.add(ore.item_class, ore.mine(amount))
        end

        mining_timer.restart
      else
        mining_timer.stop
      end
    end

    def update_inventory(keys : Keys, mouse : Mouse, map : Map)
      inventory.update(keys, mouse, map, self)

      if keys.just_pressed?(LibAllegro::KeyE)
        hide_struct_info if inventory.shown?
        inventory.show_toggle
      elsif keys.just_pressed?(LibAllegro::KeyEscape)
        inventory.hide
        hide_struct_info
      end

      if strct = struct_hud_shown
        strct.update_struct_info_slot_hovers(mouse, inventory.hud.inventory_width, inventory.hud.height)

        if mouse.left_just_pressed? && inventory.hud.hover_index.nil?
          strct.slot_click(inventory, mouse)
        end
      end
    end

    def struct_hud_shown
      if strct = struct_info
        if strct.hud_shown?
          return strct
        end
      end

      nil
    end

    def hide_struct_info
      if strct = struct_info
        strct.hide_hud

        @struct_info = nil
      end
    end

    def minable?(cell : Cell)
      distance(cell) < MiningDistance
    end

    def removable?(cell : Cell)
      distance(cell) < StructRemovalDistance
    end

    def buildable?(cell : Cell)
      distance(cell) < BuildDistance
    end

    def draw_player_x
      x + (sprite_width - width) / 2
    end

    def overlaps?(cell : Cell)
      draw_player_x < cell.x + cell.width && cell.x < draw_player_x + width &&
        y < cell.y + cell.height && cell.y < y + height
    end

    def distance(cell : Cell)
      player_x = x - width / 2
      player_y = y - height / 2
      cell_x = cell.x + cell.width / 2
      cell_y = cell.y + cell.height / 2

      dx = player_x - cell_x
      dy = player_y - cell_y

      Math.sqrt(dx * dx + dy * dy).to_i
    end

    def draw(dx, dy)
      px, py = [dx + x, dy + y]

      draw_selections(dx, dy) unless inventory.held_item
      animations.draw(px, py)
      draw_action_progress(px, py)
      draw_inventory(dx, dy)
    end

    def draw_selections(x, y)
      if ore_hover = @ore_hover
        color = minable?(ore_hover) ? nil : LibAllegro.premul_rgba_f(1, 0, 0, 0.69)
        ore_hover.draw_selection(x, y, color)
      end

      if struct_hover = @struct_hover
        color = removable?(struct_hover) ? nil : LibAllegro.premul_rgba_f(1, 0, 0, 0.69)
        struct_hover.draw_selection(x, y, color)
      end
    end

    def draw_action_progress(x, y)
      if struct_hover = @struct_hover
        if struct_removal_timer.started?
          UI::ProgressBar.new(width, ProgressBarHeight, struct_removal_timer.percent, LibAllegro.map_rgb_f(1, 0, 0)).draw_from_bottom(x, y)
        end
      elsif ore_hover = @ore_hover
        if mining_timer.started?
          UI::ProgressBar.new(width, ProgressBarHeight, mining_timer.percent).draw_from_bottom(x, y)
        end
      end
    end

    def draw_inventory(x, y)
      if held_item = inventory.held_item
        if inventory.shown? && inventory.hud.hover?
          held_item.draw_icon
        else
          color_tint = nil

          if strct = held_item.strct
            color_tint = held_item.buildable? ? LibAllegro.premul_rgba_f(0, 1, 0, 0.69) : LibAllegro.premul_rgba_f(1, 0, 0, 0.69)

            held_item.struct_overlaps.each do |overlap|
              overlap.draw_selection(x, y, color_tint)
            end

            draw_selection(x, y, color_tint) if held_item.player_overlaps?
          end

          held_item.draw_on_map(x, y, color_tint)
        end
      end

      inventory.draw

      if strct = struct_info
        strct.draw_struct_info(inventory.hud.inventory_width, inventory.hud.height)
      end
    end

    def draw_selection(dx, dy, color)
      Cell.draw_selection(dx + draw_player_x, dy + y, width, height, color)
    end

    def destroy
      animations.destroy
    end
  end
end
