module CloudBalancer::LoadBalancer::Algorithms
  module WRR

    class ErrorInCalculation < RuntimeError; end

    def select_backend
      run_algorithm
    end

    def run_algorithm
      @last_backend ||= -1
      @current_weight ||= 0
      begin
        algo
      rescue ErrorInCalculation
        retry
      end
    end

    def algo
      @new_backend = (@last_backend + 1) % @nodes.length

      if @new_backend == 0
        @current_weight = @current_weight - @nodes.gcd
        if @current_weight <= 0
          @current_weight = @nodes.max
          if @current_weight == 0
            fail ErrorInCalculation
          end
        end
      end

      if @nodes[@new_backend][:weight] >= @current_weight
        self.backend = @new_backend
      end

    end

  end
end
