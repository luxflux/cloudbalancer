module CloudBalancer
  class Runner

    attr_reader :protocol
    attr_reader :worker

    def initialize
      @protocol = CloudBalancer::Config.protocol
    end

    def run!
      @worker = "CloudBalancer::Transport::#{@protocol.to_s.camelize}".constantize.new
      @worker.consumer = "CloudBalancer::#{CloudBalancer::Config.daemon.to_s.camelize}".constantize.new
    end

  end
end
