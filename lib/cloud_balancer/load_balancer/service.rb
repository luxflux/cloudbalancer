class CloudBalancer::LoadBalancer
  Service = Struct.new :name, :nodes do

    def initialize(name, nodes = ServiceNodes.new)
      super
    end

    def to_s
      "#{name}"
    end

  end
end
