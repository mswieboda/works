require "./animation"

module Works
  class Animations
    property animation : Animation | Nil
    property animations : Hash(Symbol, Animation)

    def initialize
      @animation = nil
      @animations = Hash(Symbol, Animation).new
    end

    def add(animation : Animation, name : Symbol)
      @animations[name] = animation
    end

    def update
      # animation.update if animation
      if a = animation
        a.update
      end
    end

    def draw(x, y)
      if a = animation
        a.draw(x, y)
      end
    end

    def destroy
      animations.to_a.each do |_symbol, animation|
        animation.destroy
      end
    end

    def play(name : Symbol)
      @animation = animations[name]
    end
  end
end
