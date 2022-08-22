require "crystal_allegro"

require "./works/init"

display = Works::Init.init_display

require "./works/main"

module Works
  VERSION = "0.1.0"

  Main.run(display)
end
