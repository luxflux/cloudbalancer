class CloudBalancer::LoadBalancer

  module TCPServer

    include CloudBalancer::LoadBalancer::Algorithms::WRR

    def initialize(service)
      super
      @service = service
      @nodes = service.nodes
      @port = service.port
      @last_backend = service.last_backend
      @current_weight = service.current_weight
      select_backend
      open_backend_connection
    end

    def receive_data(data)
      @backend_connection.send_data data
    end

    def open_backend_connection
      @backend_connection = EM.connect @backend.name, @backend.port, CloudBalancer::LoadBalancer::TCPClient, self
    end

  end

end
