require "../base"
require "../../../struct/inserter/burner"
require "../../../struct/inserter/inserter"

module Works::Item::Struct::Inserter
  class Base < Struct::Base
    Key = :inserter_base
    Name = "inserter base"
    ShortCode = "IB"
    MaxAmount = 50
    Color = LibAllegro.map_rgb_f(1, 0, 1)

    def self.key
      Key
    end

    def self.name
      Name
    end

    def self.short_code
      ShortCode
    end

    def self.max_amount
      MaxAmount
    end

    def self.icon_color
      Color
    end

    def to_struct
      case key
      when :burner_inserter
        Works::Struct::Inserter::Burner.new
      when :inserter
        Works::Struct::Inserter::Inserter.new
      else
        raise "#{self.class.name}#to_struct struct not found for #{key}"
      end
    end
  end
end
