class CloudBalancer::LoadBalancer
  ServiceNode = Struct.new :name, :weight, :last_heartbeat, :online do

    include CloudBalancer::LoadBalancer::ToJsonMixin

    attr_writer :online

    def initialize(name, weight = 0, last_heartbeat = Time.now, online = false)
      super
    end

    def online?
      @online
    end

    def offline?
      !online?
    end

    def to_s
      "#{name}"
    end

  end
end

