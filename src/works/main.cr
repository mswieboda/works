module Works
  class Main
    def check_init(test, description)
      return if test

      puts "couldn't init #{description}"
      exit 1
    end

    def run
      redraw = true
      zoom = 1.0
      filename = "assets/player.png"

      check_init(CrystalAllegro.init, "crystal allegro")

      LibAllegro.set_new_display_adapter(ARGV[1].to_i) if ARGV.size > 1

      check_init(LibAllegro.install_mouse, "mouse")
      check_init(LibAllegro.install_keyboard, "keyboard")
      check_init(LibAllegro.init_image_addon, "image addon")

      display = LibAllegro.create_display(640, 480)

      check_init(display, "display")

      LibAllegro.set_window_title(display, filename)

      t0 = LibAllegro.get_time
      bitmap = LibAllegro.load_bitmap(filename)
      t1 = LibAllegro.get_time

      check_init(bitmap, "bitmap")

      puts "Loading took #{t1 - t0} seconds"

      timer = LibAllegro.create_timer(1.0 / 30)
      queue = LibAllegro.create_event_queue

      LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
      LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
      LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))
      LibAllegro.start_timer(timer) # Start the timer

      # Primary 'game' loop.
      event = LibAllegro::Event.new

      loop do
        LibAllegro.wait_for_event(queue, pointerof(event)) # Wait for and get an event.

        case event.type
        when LibAllegro::EventDisplayClose
          break
        when LibAllegro::EventKeyChar
          # Use keyboard to zoom image in and out.
          # 1: Reset zoom.
          # +: Zoom in 10%
          # -: Zoom out 10%
          # f: Zoom to width of window
          break if event.keyboard.keycode == LibAllegro::KeyEscape # Break the loop and quite on escape key.
          case event.keyboard.unichar
            when '1' then zoom = 1.0
            when '+' then zoom *= 1.1
            when '-' then zoom /= 1.1
            when 'f' then zoom = LibAllegro.get_display_width(display).to_f / LibAllegro.get_bitmap_width(bitmap)
          end
        when LibAllegro::EventTimer
          # Trigger a redraw on the timer event
          redraw = true
        end

        # Redraw, but only if the event queue is empty
        if redraw && LibAllegro.is_event_queue_empty(queue)
          redraw = false

          # Clear so we don't get trippy artifacts left after zoom.
          LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))

          if zoom == 1
            LibAllegro.draw_bitmap(bitmap, 0, 0, 0)
          else
            LibAllegro.draw_scaled_rotated_bitmap(bitmap, 0, 0, 0, 0, zoom, zoom, 0, 0)
          end

          LibAllegro.flip_display
        end
      end

      LibAllegro.destroy_bitmap(bitmap)
    end
  end
end
