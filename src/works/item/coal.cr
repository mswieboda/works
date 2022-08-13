module Works::Item
  class Coal < Base
    MaxAmount = 50

    def initialize
      super("Coal")
    end

    def draw
    end
  end
end
