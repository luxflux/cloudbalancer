module CloudBalancer
  class Status

    attr_accessor :transport, :logger

    def initialize(run_once)
      @config = CloudBalancer::Config.status
      @logger = CloudBalancer::Logger.new.logger
      @run_once = run_once
    end

    def start
      question(:status)
    end

    def handle_message(metadata, payload)
      @logger.info("Got message: #{metadata.inspect} - #{payload.inspect}")
      if @run_once
        close
      end
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
