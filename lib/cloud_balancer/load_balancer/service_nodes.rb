class CloudBalancer::LoadBalancer
  class ServiceNodes < Array

    include CloudBalancer::LoadBalancer::FindNameMixin

    def weights
      self.map { |server| server[:weight] }
    end

    def gcd
      puts weights
      my_weights = weights
      my_gcd = nil
      val = my_weights.shift
      my_weights.each do |i|
        current_gcd = val.gcd(i)
        my_gcd = current_gcd if my_gcd.nil? or current_gcd < my_gcd
      end
      my_gcd
    end

    def max
      weights.max
    end

  end
end
