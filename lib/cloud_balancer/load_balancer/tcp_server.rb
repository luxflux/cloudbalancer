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
      self.backend = nil
      select_backend
      open_backend_connection
    end

    def receive_data(data)
      @backend_connection.send_data data
    end

    def open_backend_connection
      @backend_connection = EM.connect @backend.name, @backend.port, CloudBalancer::LoadBalancer::TCPClient, self
    end

    def backend=(value)
      @service.last_backend = value unless value.nil?
      @backend = value.nil? ? value : @nodes[value]
    end

    def unbind
      @backend_connection.close_connection_after_writing if @backend_connection
      @backend_connection = nil
    end

  end

end
