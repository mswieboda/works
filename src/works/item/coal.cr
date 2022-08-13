module Works::Item
  class Coal < Base
    MaxAmount = 50

    def initialize
      super(:coal, "Coal")
    end

    def self.max_amount
      MaxAmount
    end

    def self.key
      :coal
    end

    def draw
    end
  end
end
