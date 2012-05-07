module CloudBalancer::LoadBalancer::Algorithms
  class WRR

    attr_accessor :backends, :options

    def initialize
      @backends = nil
      self.options = OpenStruct.new(backend: -1, current_weight: 0)
    end

    def options=(value)
      return false unless value.respond_to?(:current_weight) and value.respond_to?(:backend)
      @current_weight = value.current_weight
      @backend = value.backend
    end

    def get_backend
      begin
        return algorithm
      rescue CloudBalancer::LoadBalancer::Algorithms::ErrorInCalculation
        retry
      end
    end

    def options_for_next_run
      OpenStruct.new(current_weight: @current_weight, backend: @backend)
    end


    def algorithm
      @backend = (@backend + 1) % @backends.length

      if @backend == 0
        @current_weight = @current_weight - @backends.gcd
        if @current_weight <= 0
          @current_weight = @backends.max
          if @current_weight == 0
            fail ErrorInCalculation
          end
        end
      end

      if @backends[@backend].weight >= @current_weight
        @backends[@backend]
      else
        raise ErrorInCalculation
      end

    end

  end
end
