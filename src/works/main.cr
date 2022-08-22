require "./scene_manager"
require "./font"

module Works
  class Main
    def self.check_init(test, description)
      return if test

      puts "> Main::run couldn't init #{description}"

      exit 1
    end

    def self.run(display)
      timer = LibAllegro.create_timer(1.0 / Screen.fps)
      check_init(timer, "timer")

      queue = LibAllegro.create_event_queue
      check_init(queue, "queue")

      LibAllegro.register_event_source(queue, LibAllegro.get_keyboard_event_source)
      LibAllegro.register_event_source(queue, LibAllegro.get_mouse_event_source)
      LibAllegro.register_event_source(queue, LibAllegro.get_display_event_source(display))
      LibAllegro.register_event_source(queue, LibAllegro.get_timer_event_source(timer))

      event = LibAllegro::Event.new
      sceneManager = SceneManager.new

      LibAllegro.start_timer(timer)

      loop do
        LibAllegro.wait_for_event(queue, pointerof(event))

        sceneManager.update(event)

        break if sceneManager.exit?

        # Redraw, but only if the event queue is empty
        if sceneManager.redraw? && LibAllegro.is_event_queue_empty(queue)
          sceneManager.redraw = false

          LibAllegro.clear_to_color(LibAllegro.map_rgb_f(0, 0, 0))

          sceneManager.draw

          LibAllegro.flip_display
        end
      end

      sceneManager.destroy

      destroy
    end

    def self.destroy
      Font.destroy
    end
  end
end
