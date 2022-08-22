require "./base"

module Works::Tile
  class Dirt < Base
    Name = "Dirt"

    @@sprite = LibAllegro.load_bitmap("./assets/dirt.png")

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.sprite
      @@sprite
    end

    def sprite
      self.class.sprite
    end

    def draw(dx, dy)
      dx += x
      dy += y

      Sprite.draw(sprite, dx, dy)
    end
  end
end
