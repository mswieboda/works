require "./base"

module Works::Struct::Chest
  class Iron < Base
    Key = :iron_chest
    Name = "Iron chest"
    Color = LibAllegro.map_rgb(109, 100, 103)
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
