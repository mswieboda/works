require "./screen"

module Works
  module Allegro
    # Allegro constants not in bindings
    MagLinear = 0x0080
    MinLinear = 0x0040
  end

  class Init
    def self.check_init(test, description)
      return if test

      puts "> Init::init_allegro couldn't init #{description}"

      exit 1
    end

    def self.init_display
      check_init(CrystalAllegro.init, "crystal allegro")
      check_init(LibAllegro.install_keyboard, "keyboard")
      check_init(LibAllegro.install_mouse, "mouse")
      check_init(LibAllegro.init_font_addon, "font addon")
      check_init(LibAllegro.init_ttf_addon, "ttf addon")
      check_init(LibAllegro.init_image_addon, "image addon")
      check_init(LibAllegro.init_primitives_addon, "primitives addon")

      # display options for anti-aliasing
      LibAllegro.set_new_display_option(LibAllegro::SampleBuffers, 1, LibAllegro::Suggest)
      LibAllegro.set_new_display_option(LibAllegro::Samples, 8, LibAllegro::Suggest)
      LibAllegro.set_new_bitmap_flags(Allegro::MinLinear | Allegro::MagLinear)

      display = LibAllegro.create_display(Screen.width, Screen.height)
      check_init(display, "display")

      # set to fullscreen windowed
      LibAllegro.set_display_flag(display, LibAllegro::FullscreenWindow, 1)

      Screen.init(display)

      LibAllegro.set_window_title(display, Screen.name)

      display
    end
  end
end
