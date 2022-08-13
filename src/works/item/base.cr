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
      leftovers = 0

      puts "> Item::Base#add @a: #{@amount} a: #{amount} m: #{max_amount}"

      @amount += amount

      if @amount + amount > max_amount
        leftovers = @amount + amount - max_amount
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
