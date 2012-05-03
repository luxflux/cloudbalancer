class CloudBalancer::LoadBalancer

  class TCPServer

    include CloudBalancer::LoadBalancer::Algorithms::WRR

    def initialize(service)
      @service = service
      @nodes = service.nodes
      @port = service.port
      @last_backend = service.last_backend
      @current_weight = service.current_weight
      open_backend_connection
    end

    def receive_data(data)
      @backend.send data
    end

  end

end
