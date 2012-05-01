module CloudBalancer
  class Runner

    attr_reader :protocol
    attr_reader :worker

    def initialize
      @protocol = CloudBalancer::Config.protocol
    end

    def run!(mode = :auto, &block)
      @worker = "CloudBalancer::Transport::#{@protocol.to_s.camelize}".constantize.new
      consumer = "CloudBalancer::#{(mode == :auto ? CloudBalancer::Config.daemon : mode).to_s.camelize}".constantize

      if block
        @worker.consumer = consumer.new(block)
      else
        @worker.consumer = consumer.new
      end

      @worker.consumer.transport = @worker

      @worker.start
      @worker.consumer.start
    end

  end
end
