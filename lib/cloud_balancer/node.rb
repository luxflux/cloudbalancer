module CloudBalancer
  class Node

    def initialize
      @config = CloudBalancer::Config.node
    end

    def greet_loadbalancer
      greeting = {
        password: @config.password,
        services: @config.services
      }
    end

  end
end
