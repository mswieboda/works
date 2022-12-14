module Works
  module Screen
    InitialWidth = 1280_u16
    InitialHeight = 768_u16
    InitialScaleFactor = 1_u8
    InitialSpriteFactor = 0.5
    FPS = 60_u8
    Name = "works"
    Fullscreen = true

    @@width : UInt16 = InitialWidth
    @@height : UInt16 = InitialHeight
    @@scale_factor : UInt8 = InitialScaleFactor
    @@sprite_factor : Float64 = InitialSpriteFactor

    def self.width
      @@width
    end

    def self.height
      @@height
    end

    def self.fps
      FPS
    end

    def self.scale_factor
      @@scale_factor
    end

    def self.sprite_factor
      @@sprite_factor
    end

    def self.init(display)
      # set to fullscreen windowed
      LibAllegro.set_display_flag(display, LibAllegro::FullscreenWindow, 1) if Fullscreen
      LibAllegro.set_window_title(display, Name)

      @@width = LibAllegro.get_display_width(display).to_u16
      @@height = LibAllegro.get_display_height(display).to_u16
      @@scale_factor = (@@width / InitialWidth).to_u8
      @@sprite_factor = @@scale_factor * InitialSpriteFactor
    end
  end
end
