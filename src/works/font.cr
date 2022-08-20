module Works
  class Font
    def self.default
      @@font_default ||= LibAllegro.load_ttf_font("./assets/PressStart2P.ttf", 8 * Screen::ScaleFactor, 0)
    end

    def self.normal
      @@font_normal ||= LibAllegro.load_ttf_font("./assets/PressStart2P.ttf", 16 * Screen::ScaleFactor, 0)
    end

    def self.big
      @@font_big ||= LibAllegro.load_ttf_font("./assets/PressStart2P.ttf", 32 * Screen::ScaleFactor, 0)
    end

    def self.destroy
      LibAllegro.destroy_font(default)
      LibAllegro.destroy_font(normal)
      LibAllegro.destroy_font(big)
    end
  end
end
