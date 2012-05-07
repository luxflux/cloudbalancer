class CloudBalancer::LoadBalancer
  module FindNameMixin

    def find_name(name)
      find do |obj|
        obj.name == name
      end
    end

  end
end
