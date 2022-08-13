module Works::Item
  abstract class Base
    MaxAmount = 100

    getter name
    getter amount

    def initialize(name = "")
      @name = name
      @amount = 0
    end

    def self.max_amount
      MaxAmount
    end

    def max_amount
      self.class.max_amount
    end

    def add(amount)
      leftovers = 0

      @amount += amount

      if amount > max_amount
        leftovers = amount - max_amount
        @amount = max_amount
      end

      leftovers
    end

    abstract def draw

    def print
      print "#{name}: #{amount}"
    end
  end
end
