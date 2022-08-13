module Works::Item
  abstract class Base
    MaxAmount = 100

    getter key
    getter name
    getter amount

    def initialize(key = :base, name = "")
      @key = key
      @name = name
      @amount = 0
    end

    def self.key
      :base
    end

    def self.max_amount
      MaxAmount
    end

    def max_amount
      self.class.max_amount
    end

    def full?
      amount >= max_amount
    end

    def add(amount)
      total = @amount + amount

      if total > max_amount
        @amount = max_amount
      else
        @amount += amount
      end

      total - @amount
    end

    abstract def draw

    def print_str
      "#{name}: #{amount}"
    end
  end
end
