module Works
  class Timer
    @start_time : Time | Nil
    @duration : Time::Span

    def initialize(duration)
      @duration = duration
      @start_time = nil
    end

    def start
      @start_time = Time.local
    end

    def restart
      start
    end

    def started?
      @start_time != nil
    end

    def done?
      return false unless start_time = @start_time

      Time.local - start_time > @duration
    end
  end
end
