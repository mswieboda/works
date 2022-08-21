require "./base"

module Works::Struct::Chest
  class Steel < Base
    Key = :steel_chest
    Name = "Steel chest"
    Color = LibAllegro.map_rgb(139, 130, 133)
    Storage = 48

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
