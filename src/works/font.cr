module Works
  class Font
    def self.default
      @@font ||= LibAllegro.create_builtin_font
    end

    def self.normal
      @@font_normal ||= LibAllegro.load_ttf_font("./assets/PressStart2P.ttf", 16, 0)
    end

    def self.big
      @@font_big ||= LibAllegro.load_ttf_font("./assets/PressStart2P.ttf", 32, 0)
    end

    def self.destroy
      LibAllegro.destroy_font(default)
      LibAllegro.destroy_font(normal)
      LibAllegro.destroy_font(big)
    end
  end
end
