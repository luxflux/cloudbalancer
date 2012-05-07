class CloudBalancer::LoadBalancer
  Service = Struct.new :name, :ip, :port, :nodes, :algo_options do

    include CloudBalancer::LoadBalancer::ToJsonMixin

    def initialize(name, ip, port, nodes = ServiceNodes.new, algo_options = nil)
      name = name.to_sym
      super
    end

    def to_s
      "#{name}"
    end

  end
end
