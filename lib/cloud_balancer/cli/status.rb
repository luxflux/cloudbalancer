class CloudBalancer::CLI
  class Status

    def initialize
      daemon = CloudBalancer::Status.new(&self.method(:handle_message))
      transport = CloudBalancer::Transport::AMQP.new
      @runner = CloudBalancer::Runner.new(daemon, transport)
      self
    end

    def run
      @runner.run
    end

    def draw
      p @content
    end

    def handle_message(consumer, payload)
      consumer.close
      @content = payload
      draw
    end

  end
end
