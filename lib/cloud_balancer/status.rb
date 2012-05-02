module CloudBalancer
  class Status

    attr_accessor :transport, :logger

    def initialize(block)
      @config = CloudBalancer::Config.status
      @logger = CloudBalancer::Logger.new.logger

      @callback = block
    end

    def start
      question(:status)
    end

    def handle_message(metadata, payload)
      @logger.info("Got message: #{metadata.inspect} - #{payload.inspect}")
      @callback.call(self)
    end

    def close
      @transport.close
      EM.stop
    end

    protected

    def question(topic)
      @transport.question(topic)
    end

  end
end
