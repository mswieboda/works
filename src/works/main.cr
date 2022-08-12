require "./scene_manager"

module Works
  module Allegro
    # Allegro constants not in bindings
    MagLinear = 0x0080
    MinLinear = 0x0040
  end

  FPS = 60
  Width = 1024
  Height = 768
  Name = "works"

  class Main
    def check_init(test, description)
      return if test

      puts "> Main::run couldn't init #{description}"
      exit 1
    end

    def run
      check_init(CrystalAllegro.init, "crystal allegro")
      check_init(LibAllegro.install_keyboard, "keyboard")
      check_init(LibAllegro.install_mouse, "mouse")
      check_init(LibAllegro.init_font_addon, "font addon")
      # check_init(LibAllegro.init_ttf_addon, "ttf addon") # need to add to bindings
      check_init(LibAllegro.init_image_addon, "image addon")
      check_init(LibAllegro.init_primitives_addon, "primitives addon")

      timer = LibAllegro.create_timer(1.0 / FPS)
      check_init(timer, "timer")

      queue = LibAllegro.create_event_queue
      check_init(queue, "queue")

      # display options for anti-aliasing
      LibAllegro.set_new_display_option(LibAllegro::SampleBuffers, 1, LibAllegro::Suggest)
      LibAllegro.set_new_display_option(LibAllegro::Samples, 8, LibAllegro::Suggest)
      LibAllegro.set_new_bitmap_flags(Allegro::MinLinear | Allegro::MagLinear)

      display = LibAllegro.create_display(Width, Height)
      check_init(display, "display")

      LibAllegro.set_window_title(display, Name)

      # set to fullscreen windowed
      # al_set_display_flag(display, ALLEGRO_FULLSCREEN_WINDOW, true);

      # al_hide_mouse_cursor(display);

      LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
      LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
      LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
      LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))

      event = LibAllegro::Event.new
      sceneManager = SceneManager.new(Width, Height)

      LibAllegro.start_timer(timer)

      loop do
        LibAllegro.wait_for_event(queue, pointerof(event))

        sceneManager.update(event)

        break if sceneManager.exit?

        # Redraw, but only if the event queue is empty
        if sceneManager.redraw? && LibAllegro.is_event_queue_empty(queue)
          sceneManager.redraw = false

          LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))

          sceneManager.draw()

          LibAllegro.flip_display
        end
      end

      sceneManager.destroy()
    end
  end
end
