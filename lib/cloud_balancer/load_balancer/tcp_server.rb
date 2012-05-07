class CloudBalancer::LoadBalancer

  module TCPServer

    def post_init(service, algorithm)
      @service = service
      @nodes = service.nodes
      @port = service.port
      @algorithm = algorithm
      select_backend
      open_backend_connection
    end

    def receive_data(data)
      @backend_connection.send_data data
    end

    def unbind
      @backend_connection.close_connection_after_writing if @backend_connection
      @backend_connection = nil
    end

    def select_backend
      @algorithm.backends = @service.nodes
      @algorithm.options = @service.algo_options
      @backend = @algorithm.get_backend
      @service.algo_options = @algorithm.options_for_next_run
    end

    def open_backend_connection
      @backend_connection = EM.connect @backend.name, @backend.port, CloudBalancer::LoadBalancer::TCPClient, self
    end

  end

end
