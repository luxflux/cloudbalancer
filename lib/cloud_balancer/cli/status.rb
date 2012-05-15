class CloudBalancer::CLI
  class Status

    include CommandLineReporter

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
      table do
        row do
          column "Services", width: 40
          column "", width: 6
          column "", width: 40
          column "", width: 'offline'.length
        end

        @content[:services].each do |service|
          row do
            column service_name(service)
            column "Weight"
            column "Last Heartbeat"
            column ""
          end
          service[:nodes].each do |node|
            row do
              last = service[:nodes].last == node
              column node_name(node, last)
              column node[:weight]
              column node[:last_heartbeat]
              column node_state(node[:online])
            end
          end
        end
      end

    end

    def handle_message(consumer, payload)
      consumer.close
      @content = payload
      draw
    end

    def service_name(service)
      " #{service[:name]} (#{service[:ip]}:#{service[:port]})"
    end

    def node_name(node,last)
      s = last ? '`' : '+'
      "  #{s}-> #{node[:name]}:#{node[:port]}"
    end

    def node_state(online)
      online ? "online" : "offline"
    end

  end
end
