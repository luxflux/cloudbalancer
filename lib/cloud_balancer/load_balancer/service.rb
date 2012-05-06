class CloudBalancer::LoadBalancer
  Service = Struct.new :name, :ip, :port, :nodes, :last_backend, :current_weight do

    include CloudBalancer::LoadBalancer::ToJsonMixin

    def initialize(name, ip, port, nodes = ServiceNodes.new, last_backend = nil, current_weight = nil)
      name = name.to_sym
      super
    end

    def to_s
      "#{name}"
    end

  end
end
