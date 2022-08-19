module Works
  class Timer
    property duration : Time::Span

    @start_time : Time | Nil

    def initialize(duration)
      @duration = duration
      @start_time = nil
    end

    def start
      @start_time = Time.local
    end

    def stop
      @start_time = nil
    end

    def restart
      start
    end

    def started?
      @start_time != nil
    end

    def time_expired
      return Time::Span.new unless start_time = @start_time

      Time.local - start_time
    end

    def done?
      return false unless start_time = @start_time

      time_expired > @duration
    end

    def percent
      time_expired / @duration
    end
  end
end
