module CloudBalancer
  class Runner

    attr_reader :transport
    attr_reader :daemon

    def initialize(daemon, transport)
      @daemon = daemon
      @transport = transport
    end

    def run
      @daemon.transport = @transport
      @transport.daemon = @daemon

      @transport.start
      @daemon.start
      true
    end

  end
end
