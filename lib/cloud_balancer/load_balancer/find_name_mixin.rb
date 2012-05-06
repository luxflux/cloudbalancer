class CloudBalancer::LoadBalancer
  module FindNameMixin

    def find_name(name)
      find do |obj|
        puts obj.name
        puts obj.name.class
        puts name
        puts name.class
        obj.name == name
      end
    end

  end
end
