require 'socket'

module CloudBalancer
  class Node

    attr_accessor :transport, :logger

    def initialize
      @config = CloudBalancer::Config.node

      @logger = CloudBalancer::Logger.new.logger

    end

    def start
      register_with_loadbalancer
    end

    def register_with_loadbalancer
      register = {
        password: @config.cluster_password,
        services: @config.services,
        node: Socket.gethostname
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

  end
end
