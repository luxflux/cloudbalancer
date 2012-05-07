class CloudBalancer::LoadBalancer
  module Algorithms

    class ErrorInCalculation < RuntimeError; end

    autoload :WRR, 'cloud_balancer/load_balancer/algorithms/wrr'

  end
end
