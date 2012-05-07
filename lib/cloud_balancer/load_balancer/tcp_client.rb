class CloudBalancer::LoadBalancer
  module TCPClient

    def initialize(server)
      @server = server
    end

    # answer from the backend
    def receive_data(data)
      @server.send_data data
    end

  end
end
