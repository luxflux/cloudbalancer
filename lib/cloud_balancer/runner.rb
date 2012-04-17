module CloudBalancer
  class Runner

    attr_reader :protocol
    attr_reader :worker

    def initialize
      @protocol = CloudBalancer::Config.protocol
    end

    def run!(mode = :auto)
      @worker = "CloudBalancer::Transport::#{@protocol.to_s.camelize}".constantize.new
      consumer = (mode == :auto ? CloudBalancer::Config.daemon : mode).to_s.camelize
      @worker.consumer = "CloudBalancer::#{consumer}".constantize.new
    end

  end
end
