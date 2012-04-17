module CloudBalancer
  class Status

    attr_accessor :transport, :logger

    def initialize
      @config = CloudBalancer::Config.status

      @logger = CloudBalancer::Logger.new.logger

    end

    def start
      question(:status)
    end

    def handle_message(metadata, payload)
      @logger.info("Got message: #{metadata.inspect} - #{payload.inspect}")
    end

    protected

    def question(topic)
      @transport.question(topic)
    end

  end
end
