module CloudBalancer
  class Logger

    attr_reader :logger

    def initialize
      @logger = ::Logger.new(STDERR)
      @logger.level = CloudBalancer::Config.log_level.nil? ? ::Logger::WARN : CloudBalancer::Config.log_level
    end

  end
end
