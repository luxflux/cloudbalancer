module CloudBalancer::LoadBalancer::Algorithms
  module WRR

    class ErrorInCalculation < RuntimeError; end

    def select_backend
      run_algorithm
    end

    def run_algorithm
      @last_backend ||= -1
      @current_weight ||= 0
      @backend = nil
      begin
        algo
      rescue ErrorInCalculation
        retry
      end
    end

    def algo
      @last_backend = (@last_backend + 1) % @nodes.length

      if @last_backend == 0
        puts @nodes.gcd
        @current_weight = @current_weight - @nodes.gcd
        if @current_weight <= 0
          @current_weight = @nodes.max
          if @current_weight == 0
            fail ErrorInCalculation
          end
        end
      end

      if @nodes[@last_backend][:weight] >= @current_weight
        @backend = @nodes[i]
      end

    end

  end
end
