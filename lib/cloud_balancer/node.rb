require 'socket'

module CloudBalancer
  class Node

    attr_accessor :transport, :logger

    def initialize
      @config = CloudBalancer::Config.node

      @logger = CloudBalancer::Logger.new.logger

      @name = Socket.gethostname
    end

    def start
      register_with_loadbalancer
      start_heartbeat
    end

    def register_with_loadbalancer
      register = {
        password: @config.cluster_password,
        services: reg_services,
        node: @name,
      }
      publish(:register, register)
    end

    def handle_message(metadata, payload)
      @logger.info("Got message: #{metadata.inspect} - #{payload.inspect}")
    end

    protected

    def publish(type, data)
      @transport.publish(type, data)
    end

    def start_heartbeat
      EM::PeriodicTimer.new(1) do
        publish(:heartbeat, node: @name, services: services_array)
      end
    end

    def services_array
      @config.services.map { |s| s[:name] }
    end

    def reg_services
      services = {}
      @config.services.each do |s|
        services[s[:name]] = s[:node_port]
      end
      services
    end

  end
end
