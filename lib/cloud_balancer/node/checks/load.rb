module CloudBalancer
  class Node
    class Checks
      class Load

        attr_reader :system_load

        def run
          @system_load = get_load
          self
        end

        def weight
          weight = @system_load * 20
          weight.to_i
        end

        def get_load
          0.99
        end

      end
    end
  end
end
