require 'socket'

module CloudBalancer
  class Node

    autoload :Checks, 'cloud_balancer/node/checks'

    attr_accessor :transport, :logger

    def initialize
      @config = CloudBalancer::Config.node

      @logger = CloudBalancer::Logger.new.logger

      @name = @config.hostname

      @services = @config.services
    end

    def start
      register_with_loadbalancer
      start_heartbeat
      start_checks
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

    def start_checks
      EM::PeriodicTimer.new(3) do
        @services.each do |service|
          weights = service[:checks].map do |c|
            check = "CloudBalancer::Node::Checks::#{c.capitalize}".constantize.new
            check.run.weight
          end
          # average over all checks
          weight = weights.inject(:+).to_f / weights.size
          publish(:weight, value: weight, node: @name, service: service)
        end
      end
    end

    def services_array
      @services.map { |s| s[:name] }
    end

    def reg_services
      services = {}
      @services.each do |s|
        services[s[:name]] = s[:node_port]
      end
      services
    end

  end
end
