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
      if consumer == "Status"
        run_once = true
        @worker.consumer = "CloudBalancer::#{consumer}".constantize.new(run_once)
      else
        @worker.consumer = "CloudBalancer::#{consumer}".constantize.new
      end
      @worker.consumer.transport = @worker

      @worker.start
      @worker.consumer.start
    end

  end
end
