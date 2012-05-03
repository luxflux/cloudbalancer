module CloudBalancer::LoadBalancer::Algorithms
  module WRR

    def open_backend_connection
      @backend = run_algorithm
    end

    def run_algorithm
      # LVS stuff
    end

  end
end
