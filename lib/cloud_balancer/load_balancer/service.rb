class CloudBalancer::LoadBalancer
  Service = Struct.new :name, :ip, :port, :algorithm, :nodes, :algo_options do

    include CloudBalancer::LoadBalancer::ToJsonMixin

    def initialize(name, ip, port, algorithm = nil, nodes = ServiceNodes.new, algo_options = nil)
      name = name.to_sym
      algorithm ||= :wrr
      super
    end

    def to_s
      "#{name}"
    end

  end
end
