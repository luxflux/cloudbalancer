module CloudBalancer
  class Logger

    attr_reader :logger

    def initialize
      @logger = ::Logger.new(STDERR)
    end

  end
end
