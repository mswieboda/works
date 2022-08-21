require "./base"

module Works::Struct::Chest
  class Wooden < Base
    Key = :wooden_chest
    Name = "Wooden chest"
    Color = LibAllegro.map_rgb_f(0.35, 0.33, 0.31)
    Storage = 16

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.color
      Color
    end

    def self.storage
      Storage
    end
  end
end
